(cl:defpackage :glm
  (:use :cl)
  (:export))
(cl:defpackage :%glm
  (:use))
(cl:in-package :glm)


(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun instantiate-some (decl)
    (when (string= "glm" (claw.resect::declaration-namespace decl))
      (let* ((name (claw.resect::declaration-name decl))
             (location (claw.resect::declaration-location decl))
             (params (claw.resect::declaration-template-parameters decl))
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
                              (list "4" "4" type "glm::defaultp")))))))))


(claw.wrapper:defwrapper (glm::claw-glm
                          (:headers "claw_glm.hpp")
                          (:includes :glm-includes)
                          (:intrinsics :sse42 :avx)
                          (:targets :local)
                          (:instantiate #'instantiate-some)
                          (:persistent nil)
                          (:language :c++)
                          (:include-definitions "glm::.*")
                          (:exclude-definitions "glm::detail::"
                                                "vec<.*bool.*>"))
  :in-package :%glm
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :with-adapter (:static
                 :path "lib/adapter.cxx")
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer)))
