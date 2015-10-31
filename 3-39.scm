#lang racket

(define x 10)
(define s (make-serializer))
(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
				  (s (lambda () (set! x (+ x 1)))))

; まず、それぞれのプロセスに名前をつける
; P1-1 (* x x)
; P1-2 x := P1-1
; P2-1 (+ x 1)
; P2-2 x := P2-1

; serializerがなかった場合のパターンは以下のとおり
; P1-1 P1-2 P2-1 P2-2 : 101
; P1-1 P2-1 P1-2 P2-2 : 11
; P1-1 P2-1 P2-2 P1-2 : 100
; P2-1 P1-1 P1-2 P2-2 : 11
; P2-1 P1-1 P2-2 P1-2 : 100
; P2-1 P2-2 P1-1 P1-2 : 121

; (よくよく問題を読んだら、P1-1はxへのアクセス2回に分解しないとだめそうだけど、とりあえずおいておく)

; serializerによる制約により、(P1-1) -> (P2-1, P2-2) という順序が保証される
; 制約に反するパターンを除くと、以下のようになる
; P1-1 P1-2 P2-1 P2-2 : 101
; P1-1 P2-1 P2-2 P1-2 : 100
; よって、2パターンになる?でいいのかな?

