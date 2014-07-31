#lang racket

; carの再定義ができないっぽいので、適当に名前を崩してます

(define (conz x y)
  (lambda (m) (m x y)))

(define (caa z)
  (z (lambda (p q) p)))

(define (cda z)
  (z (lambda (p q) q)))

; まず、consは関数を返す。
; consが返す関数は、関数mを受け取って、関数mに対してx, yを適用した結果を返す。
;
; carは、引数zに対して、関数を適用した結果を返す。
; この関数は、引数pとqを受け取って、pの方を返す。

(caa (conz 1 2))
; (caa (conz 1 2))
; → (caa (lambda (m) (m 1 2)))
; → ((lambda (m) (m 1 2)) (lambda (p q) p))
; → ((lambda (p q) p) 1 2)
; → 1
; という感じ。

(cda (conz 1 2))

