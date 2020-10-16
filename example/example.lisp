(cl:defpackage :glm.example
  (:use :cl)
  (:export #:run))
(cl:in-package :glm.example)


(defun vec4 (vec idx)
  (cffi:mem-ref (%glm:glm-operator[] '(:pointer %glm:glm-vec4) vec :int idx) :float))


(defun (setf vec4) (value vec idx)
  (let ((ptr (%glm:glm-operator[] '(:pointer %glm:glm-vec4) vec :int idx)))
    (setf (cffi:mem-ref ptr :float) (float value 0f0))))


(defun make-vec4 (x y z w)
  (let ((instance (iffi:make-intricate-instance '%glm:glm-vec4)))
    (setf (vec4 instance 0) x
          (vec4 instance 1) y
          (vec4 instance 2) z
          (vec4 instance 3) w)
    instance))


(defun destroy-vec4 (vec)
  (iffi:destroy-intricate-instance '%glm:glm-vec4 vec))


(declaim (inline vec4-add))
(defun vec4-add (result this that)
  (%glm:glm-operator+
   '(:pointer %glm:glm-vec4) result
   '(:pointer %glm:glm-vec4) this
   '(:pointer %glm:glm-vec4) that))


(declaim (inline vec4-mult))
(defun vec4-mult (result this that)
  (%glm:glm-operator*
   '(:pointer %glm:glm-vec4) result
   '(:pointer %glm:glm-vec4) this
   '(:pointer %glm:glm-vec4) that))


(declaim (inline vec4-dot))
(defun vec4-dot (this that)
  (%glm:glm-dot
   '(:pointer %glm:glm-vec4) this
   '(:pointer %glm:glm-vec4) that))


(defun vec3 (vec idx)
  (cffi:mem-ref (%glm:glm-operator[] '(:pointer %glm:glm-vec3) vec :int idx) :float))


(defun (setf vec3) (value vec idx)
  (let ((ptr (%glm:glm-operator[] '(:pointer %glm:glm-vec3) vec :int idx)))
    (setf (cffi:mem-ref ptr :float) (float value 0f0))))


(defun make-vec3 (x y z)
  (let ((instance (iffi:make-intricate-instance '%glm:glm-vec3)))
    (setf (vec4 instance 0) x
          (vec4 instance 1) y
          (vec4 instance 2) z)
    instance))


(defun destroy-vec3 (vec)
  (iffi:destroy-intricate-instance '%glm:glm-vec3 vec))


(declaim (inline vec3-add))
(defun vec3-add (result this that)
  (%glm:glm-operator+
   '(:pointer %glm:glm-vec3) result
   '(:pointer %glm:glm-vec3) this
   '(:pointer %glm:glm-vec3) that))


(declaim (inline vec3-mult))
(defun vec3-mult (result this that)
  (%glm:glm-operator*
   '(:pointer %glm:glm-vec3) result
   '(:pointer %glm:glm-vec3) this
   '(:pointer %glm:glm-vec3) that))


(declaim (inline vec3-cross))
(defun vec3-cross (result this that)
  (%glm:glm-cross
   '(:pointer %glm:glm-vec3) result
   '(:pointer %glm:glm-vec3) this
   '(:pointer %glm:glm-vec3) that))


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

(defun run ()
  (values (run-vec3) (run-vec4)))
