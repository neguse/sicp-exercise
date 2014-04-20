; 3つの引数のうち、大きい2つの数を調べる必要がある。
; これは3C2なので、3パターンある。
; (ソートして上から2つとるという方法もあると思うが、まだソートの仕方がわからない)
;
; x < y:
;   x <  z:   x < y and z < y   -> yとz
;   z <= x:   z <= x < y        -> xとy
; y <= x:
;   y <  z:   y < z and y <= x  -> xとz
;   z <= y:   z <= y <= x       -> xとy

; 二乗
(define (square x)
  (* x x))

; 二乗の和
(define (sum-square-two x y)
  (+ (square x) (square y)))

; 大きい二つの数の二乗の和
(define (sum-square-bigger-two x y z)
  (if (< x y)
    (if (< x z)
      (sum-square-two y z)
      (sum-square-two x y))
    (if (< y z)
      (sum-square-two x z)
      (sum-square-two x y))))

(= (sum-square-bigger-two 1 2 3) 13)
(= (sum-square-bigger-two 1 3 2) 13)
(= (sum-square-bigger-two 2 1 3) 13)
(= (sum-square-bigger-two 2 3 1) 13)
(= (sum-square-bigger-two 3 1 2) 13)
(= (sum-square-bigger-two 3 2 1) 13)

