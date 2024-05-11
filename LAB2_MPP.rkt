#lang racket

; Initialize English alphabet
(define (EnglishLettersList)
  '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))
(displayln "English Alphabet:")
(displayln (EnglishLettersList))

; Generate list of random numbers from 1 to 500 
(define InitialList
  (build-list 100 (λ (_) (+ 1 (random 500)))))
(displayln "Input list:")
(displayln InitialList)

; Define alphabet power
(define alphabet-power 20)
(displayln "Alphabet power:")
(displayln alphabet-power)

; Sort list
(define (sortList lst)
  (sort lst <))
(displayln "Sorted list:")
(displayln (sortList InitialList))

; Find a first element of the list
(define (getFirstElement lst)
  (car lst))
(displayln "First element of sorted list:")
(displayln (getFirstElement (sortList InitialList)))

; Find a last element of the list
(define (getLastElement lst)
  (last lst))
(displayln "Last element of sorted list:")
(displayln (getLastElement (sortList InitialList)))

; Generate segment ends needed for exponential distribution
(define (equalSegmentEnds min max count)
  (define segment-length (/ (- max min) count))
  (define (generate-ends i current ends)
    (if (<= i count)
        (generate-ends (+ i 1)
                       (+ current segment-length)
                       (cons current ends))
        (reverse (cons max ends)))) 
  (generate-ends 1 min '()))

; // Exponential distribution
(define (exponentialDistribution o power)
  (define (exponential x o)
    (* (/ 1 o) (exp (/ (- x) o))))  
  (define xValues (range 0.01 1 (/ 1 power)))
  (define yValues (map (λ (x) (exponential x o)) xValues))
  
  (list xValues yValues))

(define o 1)

(displayln "Exponential distribution")
(define points (exponentialDistribution o (+ alphabet-power 1)))
(displayln points)

(define (multiplyItemsInList a b)
  (map * a b))

(define (insertAtEnd lst item)
  (if (null? lst)
      (list item)
      (cons (car lst) (insertAtEnd (cdr lst) item))))

(define exponentialSegment (multiplyItemsInList (car (cdr points)) (equalSegmentEnds (getFirstElement(sortList InitialList)) (getLastElement (sortList InitialList)) alphabet-power)))
(define exponentialSegmentEnds (insertAtEnd exponentialSegment (getLastElement (sortList InitialList))))
(displayln "Segments for exponential distribution:")
(displayln exponentialSegmentEnds)

; Classify numbers according to segments
(define (segmentIndices numbers segments)
  (define (findSegmentIndex num)
    (let loop ((i 0))
      (cond ((>= i (- (length segments) 1)) (- (length segments) 1))
            ((and (>= num (list-ref segments i))
                  (< num (list-ref segments (+ i 1))))
             i)
            (else (loop (+ i 1))))))
  (map (λ (num)
         (let ((index (findSegmentIndex num)))
           (if (not (eq? index #f)) index (- (length segments) 1))))
       numbers))

(displayln "Segment indices:")
(displayln (segmentIndices InitialList exponentialSegmentEnds))

; // Transform numbers to letters using english alphabet
(define (numbersToLetters numbers)
  (define letters (EnglishLettersList))
  (map (λ (num) (list-ref letters num)) numbers))

(displayln "Transform number to letters:")
(displayln (numbersToLetters (segmentIndices InitialList exponentialSegmentEnds)))

; Building a matrix 
(define (GetCrossOfMatrix current-item inner-classified-list-without-first-item inner-current-class inner-next-class)
  (if (= 0 (length inner-classified-list-without-first-item))
      0 
      (if (and (= inner-current-class current-item) (= inner-next-class (car inner-classified-list-without-first-item)))
          (+ 1
             (GetCrossOfMatrix (car inner-classified-list-without-first-item) (cdr inner-classified-list-without-first-item) inner-current-class inner-next-class))
          (GetCrossOfMatrix (car inner-classified-list-without-first-item) (cdr inner-classified-list-without-first-item) inner-current-class inner-next-class))))

(define (GetLineOfMatrix classified-list num-of-classes current-class)
  (define (helper current)
    (if (= current num-of-classes)
        (displayln "|")
        (begin
          (display (GetCrossOfMatrix (car classified-list) (cdr classified-list) current-class current))
          (display " ") 
          (helper (add1 current))))) 
  
  (helper 0))

(define (DisplayAllLinesOfMatrix list num-of-classes letters)
  (define (helper current letters)
    (if (= current num-of-classes)
        (displayln "-") 
        (begin
          (display (car letters))
          (display " ")
          (GetLineOfMatrix list num-of-classes current) 
          (helper (add1 current) (cdr letters))))) 

 (define (firstLineHelper current letters)
    (if (= current num-of-classes)
        (displayln "+") 
        (begin
          (display (car letters))
          (display " ")
          (firstLineHelper (add1 current) (cdr letters))))) 

  (display "  ")
  (firstLineHelper 0 letters) 
  (helper 0 letters)) 

(displayln "Matrix:")
(DisplayAllLinesOfMatrix (segmentIndices InitialList exponentialSegmentEnds)
                             (length exponentialSegmentEnds)
                             (EnglishLettersList))
