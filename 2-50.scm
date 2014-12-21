#lang racket
(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))

; ライブラリのtransform-painterとsicpのtransform-painterは
; 違うっぽい
; ライブラリに合わせるとこんな感じ

(define (my-flip-horiz p)
  ((transform-painter
	(make-vect 1.0 0.0)
	(make-vect 0.0 0.0)
	(make-vect 1.0 1.0)) p))

(paint einstein)
(paint (my-flip-horiz einstein))

(define (my-rot-180 p)
  ((transform-painter
	(make-vect 1.0 1.0)
	(make-vect 0.0 1.0)
	(make-vect 1.0 0.0)) p))

(paint einstein)
(paint (my-rot-180 einstein))

(define (my-rot-270 p)
  ((transform-painter
	(make-vect 0.0 1.0)
	(make-vect 0.0 0.0)
	(make-vect 1.0 1.0)) p))

(paint einstein)
(paint (my-rot-270 einstein))

; 270は結果から考えてこうなったけど、
; あまり納得いっていない
