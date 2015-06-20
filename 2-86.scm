#lang racket

; これまともにやろうとするとだいぶかかりそうなので、簡単に方針だけ考えるのに留める。

; 安直に考えると、型が入れ子にできればいいのかなーという気がする。
; そうすると、scalar of number的な型と、vector of number的な型ができる気がする。
; 整数のcomplexは、'(complex (integer integer)) みたいな型になって、
; 有理数のcomplexは、'(complex (rational rational)) みたいな型になる。
; 現在の仕組みだと、それぞれの演算子は引数型にのみ依存していて
; 返り値の型をチェックするような仕組みはないので、
; imag-partとかの分解演算子が入れ子要素の型の値を返せるように慣れば
; それで済みそう。
; ということは、型自体は(complex (integer integer))とかにしなくて
; complex型のままでいいのかな。
; たぶん、構成子と分解演算子だけ変えれば済む気がします。

