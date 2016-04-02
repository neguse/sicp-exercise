#lang racket

; applyの引数として渡すoperatorの部分をforceしておく必要がある理由
; applyの処理って、primitive-procedure?かcompound-procedure?かによって分岐するので
; forceしておかないとどっちだかわからなくてだめな気がする。

