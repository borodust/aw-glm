(cl:defpackage :glm.example
  (:use :cl)
  (:export #:run
           #:load-glm
           #:close-glm))
(cl:in-package :glm.example)


(cffi:define-foreign-library (glm
                              :search-path (asdf:system-relative-pathname :aw-glm/wrapper "src/lib/build/desktop/"))
  (:linux "libglm.clawed.so"))


(defun vec4 (vec idx)
  (cffi:mem-ref (%glm:glm+operator[]
                 :const
                 '(:pointer %glm::glm+vec<4+float>) vec
                 '%glm::glm+vec+length-type idx)
                :float))


(defun (setf vec4) (value vec idx)
  (let ((ptr (%glm:glm+operator[]
              '(:pointer %glm:glm+vec<4+float>) vec
              '%glm::glm+vec+length-type idx)))
    (setf (cffi:mem-ref ptr :float) (float value 0f0))))


(defun make-vec4 (x y z w)
  (let ((instance (iffi:make-intricate-instance '%glm::glm+vec<4+float>)))
    (setf (vec4 instance 0) (float x 0f0)
          (vec4 instance 1) (float y 0f0)
          (vec4 instance 2) (float z 0f0)
          (vec4 instance 3) (float w 0f0))
    instance))


(defun destroy-vec4 (vec)
  (iffi:destroy-intricate-instance '%glm:glm+vec<4+float> vec))


(declaim (inline vec4-add))
(defun vec4-add (result this that)
  (%glm:glm+operator+
   '(:pointer %glm:glm+vec<4+float>) result
   '(:reference %glm:glm+vec<4+float>) this
   '(:reference %glm:glm+vec<4+float>) that))


(declaim (inline vec4-mult))
(defun vec4-mult (result this that)
  (%glm:glm+operator*
   '(:pointer %glm:glm+vec<4+float>) result
   '(:reference %glm:glm+vec<4+float>) this
   '(:reference %glm:glm+vec<4+float>) that))


(declaim (inline vec4-dot))
(defun vec4-dot (this that)
  (%glm:glm+dot
   '(:reference %glm:glm+vec<4+float>) this
   '(:reference %glm:glm+vec<4+float>) that))


(defun vec3 (vec idx)
  (cffi:mem-ref (%glm:glm+operator[]
                 :const
                 '(:pointer %glm::glm+vec<3+float>) vec
                 '%glm::glm+vec+length-type idx)
                :float))


(defun (setf vec3) (value vec idx)
  (let ((ptr (%glm:glm+operator[]
              '(:pointer %glm::glm+vec<3+float>) vec
              '%glm::glm+vec+length-type idx)))
    (setf (cffi:mem-ref ptr :float) (float value 0f0))))


(defun make-vec3 (x y z)
  (let ((instance (iffi:make-intricate-instance '%glm::glm+vec<3+float>)))
    (setf (vec3 instance 0) (float x 0f0)
          (vec3 instance 1) (float y 0f0)
          (vec3 instance 2) (float z 0f0))
    instance))


(defun destroy-vec3 (vec)
  (iffi:destroy-intricate-instance '%glm:glm+vec<3+float> vec))


(declaim (inline vec3-add))
(defun vec3-add (result this that)
  (%glm:glm+operator+
   '(:pointer %glm:glm+vec<3+float>) result
   '(:reference %glm:glm+vec<3+float>) this
   '(:reference %glm:glm+vec<3+float>) that))


(declaim (inline vec3-mult))
(defun vec3-mult (result this that)
  (%glm:glm+operator*
   '(:pointer %glm:glm+vec<3+float>) result
   '(:reference %glm:glm+vec<3+float>) this
   '(:reference %glm:glm+vec<3+float>) that))


(declaim (inline vec3-cross))
(defun vec3-cross (result this that)
  (%glm:glm+cross
   '(:pointer %glm:glm+vec<3+float>) result
   '(:reference %glm:glm+vec<3+float>) this
   '(:reference %glm:glm+vec<3+float>) that))


;;;
;;; DEMO
;;;
(defun run-vec3 ()
  (let ((result (make-vec3 4 1 2))
        (this (make-vec3 4 1 2))
        (that (make-vec3 3 2 1)))
    (loop repeat 10000000
          do (vec3-cross result this that))
    (values (vec3 result 0)
            (vec3 result 1)
            (vec3 result 2))))


(defun run-vec4 ()
  (let ((this (make-vec4 4 3 2 1))
        (that (make-vec4 1 2 3 4))
        result)
    (loop repeat 100000000
          do (setf result (vec4-dot this that)))
    (values result)))


(defun load-glm ()
  (cffi:load-foreign-library 'glm))


(defun close-glm ()
  (cffi:close-foreign-library 'glm))


(defun run ()
  (values (run-vec3) (run-vec4)))
