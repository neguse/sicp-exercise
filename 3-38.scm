#lang racket

; a. 
; まず、それぞれのプロセスに名前をつける。
; P1 (set! balance (+ balance 10))
; P2 (set! balance (- balance 20))
; P3 (set! balance (- balance (/ balance 2)))

; プロセス並び順は,3*2*1=6通り
; すなわち、以下のパターンがある
; P1 P2 P3 : balance = 45
; P1 P3 P2 : balance = 35
; P2 P1 P3 : balance = 45
; P2 P3 P1 : balance = 50
; P3 P1 P2 : balance = 40
; P3 P2 P1 : balance = 40

; b.
; それぞれのプロセスを細分化すると、

; P1-1 load balance
; P1-2 calc P1-1 + 10
; P1-3 store P1-2 to balance

; P2-1 load balance
; P2-2 calc P2-1 - 20
; P2-3 store P2-2 to balance

; P3-1 load balance
; P3-2 load balance
; P3-3 calc P3-2 / 2
; P3-4 calc P3-1 - P3-3
; P3-5 store P3-4 to balance

; で、同じプロセスの間ではシーケンシャルに動くけど
; それぞれのプロセスは混ざりうるので、
; パターンあらいだすのが非常に面倒ですね。

; 一番得する例と一番損する例を挙げてみる

; 得するときは減算がなかったことになればよいので、
; P1-1, P1-2, (それ以外全部), P1-3
; -> 110

; 損するときは加算がなくなったことになって、かつ除算→減算の順だとよいので
; P3全部、P2-1, P2-2, P1全部、P2-3
; -> 30

; という感じかなぁ
