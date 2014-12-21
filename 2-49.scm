#lang racket
(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))

; うーん、よくわからんけど
; ライブラリ関数は上書きしないほうが良さそうっていうのと
; lang planet neil/sicp だとうまく動かんかった

(define outline-segments
  (let
	((v1 (make-vect 0.0 0.0))
	 (v2 (make-vect 0.99 0.0))
	 (v3 (make-vect 0.99 0.99))
	 (v4 (make-vect 0.0 0.99)))
	(list
	  (make-segment v1 v2)
	  (make-segment v2 v3)
	  (make-segment v3 v4)
	  (make-segment v4 v1))))

(paint
  (segments->painter outline-segments))

(define cross-segments
  (let
	((v1 (make-vect 0.0 0.0))
	 (v2 (make-vect 0.99 0.0))
	 (v3 (make-vect 0.99 0.99))
	 (v4 (make-vect 0.0 0.99)))
	(list
	  (make-segment v1 v3)
	  (make-segment v2 v4))))

(paint
  (segments->painter cross-segments))

(define diamond-segments
  (let
	((v1 (make-vect 0.5 0.0))
	 (v2 (make-vect 0.99 0.5))
	 (v3 (make-vect 0.5 0.99))
	 (v4 (make-vect 0.0 0.5)))
	(list
	  (make-segment v1 v2)
	  (make-segment v2 v3)
	  (make-segment v3 v4)
	  (make-segment v4 v1))))

(paint
  (segments->painter diamond-segments))

; waveは座標が示されていないから無理なんじゃないかのう

