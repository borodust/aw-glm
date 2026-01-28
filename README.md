# AW-GLM

Bindings to [GLM](https://github.com/g-truc/glm) math library for [alien-works](https://github.com/borodust/alien-works) project.

## Build GLM

#### Linux
```sh
cd src/lib/ && ./build.sh desktop
```

## Example
Link `aw-glm` into quicklisp's local-projects.
And once GLM is built:
```common-lisp
(ql:quickload :aw-glm/example)
(glm.example:load-glm)
(unwind-protect
    (time (glm.example:run))
  (glm.example:close-glm))
```
