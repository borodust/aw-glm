(asdf:defsystem :claw-glm
  :description "Wrapper over OpenGL Mathematics (GLM) library"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:claw-glm-bindings))


(asdf:defsystem :claw-glm/wrapper
  :description "Wrapper over OpenGL Mathematics (GLM) library"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:alexandria :cffi :claw :claw-utils)
  :serial t
  :pathname "src/"
  :components ((:file "claw")
               (:module :bindings)
               (:module :glm-includes :pathname "lib/glm/")))


(asdf:defsystem :claw-glm/example
  :description ""
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:claw-glm)
  :serial t
  :pathname "example/"
  :components ((:file "example")))
