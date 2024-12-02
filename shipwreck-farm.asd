#|
This file is a part of shipwreck-farm
(c) 2024 Janne Pakarinen (gingeralesy@gmail.com)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:cl-user)
(asdf:defsystem shipwreck-farm
  :version "0.0.0"
  :license "zlib"
  :author "Janne Pakarinen <gingeralesy@gmail.com>"
  :maintainer "Janne Pakarinen <gingeralesy@gmail.com>"
  :description "A game project for the purpose of creating Trial tutorial based on it."
  :serial T
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "game"
  :entry-point "shipwreck-farm::launch"
  :components ((:file "package")
               (:file "main" :depends-on ("package"))
               (:file "farmer" :depends-on ("package" "main"))
               (:file "game" :depends-on ("package" "main" "farmer")))
  :depends-on (:trial
               :trial-glfw
               :trial-alloy
               :trial-png))
