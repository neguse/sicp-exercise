#lang racket

; うーん、個人的にはグローバルに遅延評価を行う処理系ってどうなの?という立場なので
; Benさんのでいいんじゃという考えなんですけど。

;(define (analyze-unless exp)
;  (let ((pproc (analyze (unless-predicate exp)))
;        (cproc (analyze (unless-consequent exp)))
;        (aproc (analyze (unless-alternative exp))))
;    (lambda (env)
;      (if (false? (pproc env))
;          (cproc env)
;          (aproc env)))))
; 実装はこんな感じで…すごい手抜き。

; 手続きとして使えるとよい箇所っていうのは、
; …問題文にあるとおり、高階手続きと使えるかどうかなんですかね。
