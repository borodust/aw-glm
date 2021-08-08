(cl:defpackage :glm
  (:use :cl)
  (:export))
(cl:defpackage :%glm
  (:use))
(cl:in-package :glm)


(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun instantiate-some (decl)
    (when (string= "glm" (claw.resect:declaration-namespace decl))
      (let* ((name (claw.resect:declaration-name decl))
             (location (claw.resect:declaration-location decl))
             (params (claw.resect:declaration-template-parameters decl))
             (types (cond
                      ((member name '("isMultiple"
                                      "findMSB"
                                      "bitCount"
                                      "bitfieldReverse") :test #'string=)
                       nil)
                      ((or (member name
                                   '("operator&"
                                     "operator|"
                                     "operator^"
                                     "operator>>"
                                     "operator<<"
                                     "operator%"
                                     "operator~"
                                     "ceilPowerOfTwo"
                                     "roundPowerOfTwo"
                                     "floorPowerOfTwo")
                                   :test #'string=)
                           (search "integer." location))
                       '("glm::uint"))
                      (t
                       '("float")))))
        (loop for type in types
              append (cond
                       ((equal '("T") params)
                        (list (list type)))
                       ((equal '("T" "Q") params)
                        (list (list type "glm::defaultp")))
                       ((equal '("L" "T" "Q") params)
                        (list (list "2" type "glm::defaultp")
                              (list "3" type "glm::defaultp")
                              (list "4" type "glm::defaultp")))
                       ((equal '("C" "R" "T" "Q") params)
                        (list (list "2" "2" type "glm::defaultp")
                              (list "3" "3" type "glm::defaultp")
                              (list "4" "4" type "glm::defaultp"))))))))

  (defun ignore-some ()
    (claw.resect:ignore-names "vec<.*bool.*>")))


(claw.wrapper:defwrapper (:aw-glm
                          (:system :aw-glm/wrapper)
                          (:headers "claw_glm.hpp")
                          (:includes :glm-includes)
                          (:instantiate #'instantiate-some)
                          (:include-definitions "glm::.*")
                          (:exclude-definitions "glm::detail::")
                          (:targets ((:and :x86-64 :linux) "x86_64-pc-linux-gnu"
                                     (:intrinsics :sse42 :avx))
                                    ((:and :aarch64 :android) "aarch64-linux-android"
                                     (:intrinsics :neon)))
                          (:persistent :aw-glm-bindings
                           :asd-path "../aw-glm-bindings.asd"
                           :bindings-path "../bindings/"
                           :depends-on (:claw-utils))
                          (:language :c++))
  :in-package :%glm
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :ignore-entities (ignore-some)
  :with-adapter (:static
                 :path "lib/adapter.cxx")
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer)))
