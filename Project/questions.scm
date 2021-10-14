(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement.

(define (cons-all first rests)
    (map (lambda (l) (cons first l)) rests)
)

(define (zip pairs)
     `(,(map (lambda (pair) (car pair)) pairs) ,(map (lambda (pair) (car(cdr pair))) pairs))
)

;; Problem 16
;; Returns a list of two-element lists
(define (enumerate s)
  ; BEGIN PROBLEM 16
    (define (helper lst index)
         (if (null? lst) '()
              (cons (cons index (list (car lst))) (helper (cdr lst) (+ index 1)))))
     (helper s 0)
  )
  ; END PROBLEM 16

;; Problem 17
;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
  ; BEGIN PROBLEM 17
  (if (or (= total 0) (null? denoms)) '()
       (begin
            (define with-first
                 (cond
                      ((= total (car denoms)) `((,total)))
                      ((> total (car denoms))
                       (cons-all (car denoms) (list-change (- total (car denoms)) denoms))
                       )
                      (else '()
                       )))
            (define without-first (list-change total (cdr denoms)))
            (append with-first without-first)
    )
   )
 )                      
  ; END PROBLEM 17

;; Problem 18
;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
         ; BEGIN PROBLEM 18
         expr
         ; END PROBLEM 18
         )
        ((quoted? expr)
         ; BEGIN PROBLEM 18
         `(quote ,(car (cdr expr)))
         ; END PROBLEM 18
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 18
          (define b (map let-to-lambda body))
           (append `(,form ,params) b)
           ; END PROBLEM 18
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 18
          (define h (map let-to-lambda values))
           (define form (zip h))
           (define b (map let-to-lambda body))
           (define ht (map let-to-lambda (car(cdr form))))
           (append `(,(append `(lambda ,(car form)) b)) ht)))
           ; END PROBLEM 18
        (else
         ; BEGIN PROBLEM 18
         (define hhh (map let-to-lambda (cdr expr)))
         (append `(,(car expr)) hhh)
         ; END PROBLEM 18
         )))
