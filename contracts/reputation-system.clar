;; Reputation System Contract

;; Data Maps
(define-map user-ratings
  { user: principal }
  { total-score: uint, review-count: uint }
)

(define-map user-reviews
  { reviewer: principal, reviewee: principal }
  { rating: uint, comment: (string-ascii 500) }
)

;; Functions
(define-public (leave-review (reviewee principal) (rating uint) (comment (string-ascii 500)))
  (begin
    (asserts! (and (>= rating u1) (<= rating u5)) (err u400))
    (map-set user-reviews
      { reviewer: tx-sender, reviewee: reviewee }
      { rating: rating, comment: comment }
    )
    (let
      (
        (current-stats (default-to { total-score: u0, review-count: u0 }
          (map-get? user-ratings { user: reviewee })))
      )
      (map-set user-ratings
        { user: reviewee }
        {
          total-score: (+ (get total-score current-stats) rating),
          review-count: (+ (get review-count current-stats) u1)
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-user-reputation (user principal))
  (let
    (
      (stats (default-to { total-score: u0, review-count: u0 }
        (map-get? user-ratings { user: user })))
    )
    (if (is-eq (get review-count stats) u0)
      u0
      (/ (get total-score stats) (get review-count stats))
    )
  )
)

(define-read-only (get-review (reviewer principal) (reviewee principal))
  (map-get? user-reviews { reviewer: reviewer, reviewee: reviewee })
)

