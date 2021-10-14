
; Tail recursion

(define (replicate x n)
  (define (helper x n r)
       (if (= n 0)
            r
            (helper x (- n 1) (append r (list x)))))
 (helper x n nil)
)

(define (accumulate combiner start n term)
    (if (=  n 0)
         start
         (combiner (accumulate combiner start (- n 1) term) (term n)))    
)

(define (accumulate-tail combiner start n term)
  (if (= n 0)
   start
   (accumulate-tail combiner (combiner start (term n)) (- n 1) term))
)

; Streams

(define (map-stream f s)
    (if (null? s)
    	nil
    	(cons-stream (f (car s)) (map-stream f (cdr-stream s)))))

(define multiples-of-three
 (begin
 (define (int-stream start)
      (cons-stream start (int-stream (+ start 1))))
  (map-stream (lambda (x) (* x 3)) (int-stream 1)))
)


(define (nondecreastream s)
     (define (helper n lst s)
          (if (or (null? s) (< (car s) n))
               (cons-stream lst (nondecreastream s))
               (helper (car s) (append lst (list (car s))) (cdr-stream s))
           )
      )
     (if (null? s)
          ()
          (helper (car s) (list (car s)) (cdr-stream s))
      )
)


(define finite-test-stream
    (cons-stream 1
        (cons-stream 2
            (cons-stream 3
                (cons-stream 1
                    (cons-stream 2
                        (cons-stream 2
                            (cons-stream 1 nil))))))))

(define infinite-test-stream
    (cons-stream 1
        (cons-stream 2
            (cons-stream 2
                infinite-test-stream))))
