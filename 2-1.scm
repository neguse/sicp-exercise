#lang racket

; これ整理すると、
; numer|denom|result
;   +  |  +  |   +
;   -  |  +  |   -
;   +  |  -  |   -
;   -  |  -  |   +
;
; うーん、符号だけとりだす関数とかあればいいですね。
; …sgn関数らしい。

(define (make-rat n d)
  (let ((g (gcd n d)))
	(cons (* (sgn d) (/ n g)) (/ (abs d) g))))

(make-rat 1 1)
(make-rat 1 -1)
(make-rat -1 1)
(make-rat -1 -1)
; '(1 . 1)
; '(-1 . 1)
; '(-1 . 1)
; '(1 . 1)
; よしよし。
; 分母が0だとおかしくなるけど、もともとおかしいはずだし、対応外ということで。

