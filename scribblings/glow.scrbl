#lang scribble/manual

@(require "glow-code.rkt"
          (only-in scribble/racket make-variable-id)
          (for-label glow)
          (for-syntax racket/base))

@title[#:style '(toc)]{Glow}

@defmodule[glow #:lang #:packages ()]

@local-table-of-contents[]

@include-section["glow-tutorial.scrbl"]

@include-section["glow-reference-manual.scrbl"]

@include-section["glow-how-to.scrbl"]

@include-section["glow-explanation.scrbl"]

@index-section[]