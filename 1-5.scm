(define (p) (p))

(define (test x y)
  (if (= x 0)
    0
    y))

(test 0 (p))

; こたえ(追記:これはたぶん間違ってる)
; normal-order evaluation
; (test 0 (p))
; -> (if (= 0 0)
;        0
;        (p))
; -> (if (= 0 0)
;        0
;        (p))
; -> これ無限再帰ですか?
;    Schemeだとtail call optimizationがあるから
;    スタックオーバーフローしないんですよね。(と知ったかぶる)
;
; applicative-order evaluation
; (test 0 (p))
; -> (if (= 0 0)
;        0
;        (p))
; -> (if #t 0 (p))
; -> 0

; Racketで試したところ、無限再帰するっぽかった。
; Racketはnormal-order evaluationなのか?
; http://stackoverflow.com/questions/4422390/does-the-drracket-interpreter-use-normal-order-evaluation-based-on-sicp-exercise
; うーんと、normal-order evaluationとapplicative-order evaluationの理解が間違ってるっぽい。
; normal-order evaluationは、
; > 基本的演算子だけを持つ式が出てくるまで, パラメタへの被演算子の式の置換えを繰り返し, それから評価を行う. 
; なので、pを置き換えようとして無限再帰になる。
; applicative-order evaluationだと、if文でfalse節の式を評価することは無いから、無限再帰しない。
; RacketでStep実行してみる… あっ!(test 0 (p)) の(p)の評価でとまってるのか!

; こたえ(たぶん合ってる)
; normal-order evaluation
; (test 0 (p))
; -> (if (= 0 0)
;        0
;        (p))
; -> (if #t
;        0
;        (p))
; -> 0
; たぶんnormal-order evaluationであろうと、
; if文の評価の際はpredicate節の評価
; ->結果に応じてconsequest節かalternative節の評価
; という順に評価される。
;
; applicative-order
; (test 0 (p))
; -> (<test を表す機械語列> <0を表すバイト列> <(p)を評価しようとして無限再帰>)
; という感じになる。

