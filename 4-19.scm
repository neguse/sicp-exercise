#lang racket

; うーん、どれも微妙な気がする。
; Racketだとエラーになった。
; 
; a: undefined;
;  cannot use before initialization
;   context...:
;    /usr/share/racket/collects/racket/private/misc.rkt:87:7

; Evaさんのは、デフォルト遅延評価にすればいいんじゃないでしょうか。
