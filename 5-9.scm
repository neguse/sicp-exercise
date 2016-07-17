#lang racket

; make-assign > make-primitive-exp
; make-assign > make-operation-exp > make-primitive-exp
; make-test > make-operation-exp > make-primitive-exp
; make-perform > make-operation-exp > make-primitive-exp
; make-primitive-expは2箇所で使われているので変えるわけにいかなくて、
; make-operation-expを変えるか、make-primitive-expのバリエーションを作るかの二択っぽい。
; とりあえずmake-primitive-expのバリエーションmake-operation-primitive-expをつくって、
; make-operation-expからはそっちを呼ぶようにしてみた。

