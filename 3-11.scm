#lang racket

; after step (define acc (make-account 50))
; acc -> make-account 50
;        -> withdraw
;        -> deposit
;        -> dispatch

; after step ((acc 'deposit) 40)
; acc -> make-account 90
;        -> withdraw
;        -> deposit
;        -> dispatch

; after step ((acc 'withdraw) 60)
; acc -> make-account 30
;        -> withdraw
;        -> deposit
;        -> dispatch

; accの内部状態は、make-account時に作成された環境に保存されている

; make-accountごとに環境が作成されるので、
; accとacc2はaccount情報は共有されない。
; 構造的には、withdrawとdepositとdispatchをもつ、というところは共通で、
; 値的には、withdrawとdepositとdispatchに束縛されている関数が共通なんじゃないか。

; …と思って答えを見たが、えー、って感じだった
; 少なくともE1のbalanceはset!されてるので30なんじゃないの?って気がする。
