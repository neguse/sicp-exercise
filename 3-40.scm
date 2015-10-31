#lang racket

(define x 10)

(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))

; まず、それぞれのプロセスに名前をつける
; P1-1 read x
; P1-2 read x
; P1-3 x := P1-1 * P1-2
; P2-1 read x
; P2-2 read x
; P2-3 read x
; P2-4 x := P2-1 * P2-2 * P2-3

; パターンを列挙するとひどいことになりそうなので、ちょっと考える。
; 各プロセスのsetが、他方のPのどこに入るかが問題となりそう。

; P1-3が全体の処理の末尾にくる場合、P2-4が入りうる場所は
; before P1-1 : 10^3 * 10^3 = 10^6
; before P1-2 : 10^1 * 10^3 = 10^4
; before P1-3 : 10^1 * 10^1 = 10^2

; P2-4が全体の処理の末尾にくる場合、P1-3が入りうる場所は
; before P2-1 : 10^2 * 10^2 * 10^2 = 10^6
; before P2-2 : 10^1 * 10^2 * 10^2 = 10^5
; before P2-3 : 10^1 * 10^1 * 10^2 = 10^4
; before P2-4 : 10^1 * 10^1 * 10^1 = 10^3

; ということで、10^2 ~ 10^6の5パターンの答えがありうる。

(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (* x x x)))))

; これでserializeした場合は、(P1-1, P1-2, P1-3) -> (P2-1, P2-2, P2-3, P2-4)が保証されるので
; 10^6の1パターンのみになります!

; …と思ったのだけど、serializerってそれぞれのPがatomicに実行されることは保証するけど
; それぞれのPの実行順序は保証されないのね。
; つまり、(P2-1, P2-2, P2-3, P2-4) -> (P2-1, P1-2, P1-3)もありうるみたいです。
; まあ、この問題は答えかわらないけど…

