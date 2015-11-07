#lang racket

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))

; 最初mapのところ勘違いしてたのですが、
; 階差数列的な感じになるんですね。

; seq: 1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210

(stream-ref y 7)
; y: 6 10 28 36 66 78 120 136 190 210
; 120... かとおもいきや0originなので136っぽい

(display-stream z)
; z: 10 15 55 105 120 190 210

; sum: 210

; メモ化しなかった場合は、sumがさらに累積になるんですよ。

