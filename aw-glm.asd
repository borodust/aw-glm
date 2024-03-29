(asdf:defsystem :aw-glm
  :description "Wrapper over OpenGL Mathematics (GLM) library"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:aw-glm-bindings))


(asdf:defsystem :aw-glm/wrapper
  :description "Wrapper over OpenGL Mathematics (GLM) library"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:alexandria :cffi :claw :claw-utils)
  :serial t
  :components ((:file "src/claw")
               (:module :wrapper-includes :pathname "src/lib/")
               (:module :glm-includes :pathname "src/lib/glm/")))


(asdf:defsystem :aw-glm/example
  :description ""
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:aw-glm)
  :serial t
  :pathname "example/"
  :components ((:file "example")))
