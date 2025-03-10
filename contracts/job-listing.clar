;; Job Listing Contract

;; Data Maps
(define-map jobs
  { job-id: uint }
  {
    client: principal,
    title: (string-ascii 100),
    description: (string-ascii 1000),
    budget: uint,
    status: (string-ascii 20),
    freelancer: (optional principal)
  }
)

(define-map job-applications
  { job-id: uint, applicant: principal }
  { application-id: uint }
)

;; Variables
(define-data-var job-id-counter uint u0)
(define-data-var application-id-counter uint u0)

;; Functions
(define-public (post-job (title (string-ascii 100)) (description (string-ascii 1000)) (budget uint))
  (let
    (
      (new-job-id (+ (var-get job-id-counter) u1))
    )
    (map-set jobs
      { job-id: new-job-id }
      {
        client: tx-sender,
        title: title,
        description: description,
        budget: budget,
        status: "open",
        freelancer: none
      }
    )
    (var-set job-id-counter new-job-id)
    (ok new-job-id)
  )
)

(define-public (apply-for-job (job-id uint))
  (let
    (
      (new-application-id (+ (var-get application-id-counter) u1))
    )
    (map-set job-applications
      { job-id: job-id, applicant: tx-sender }
      { application-id: new-application-id }
    )
    (var-set application-id-counter new-application-id)
    (ok new-application-id)
  )
)

(define-public (award-job (job-id uint) (freelancer principal))
  (let
    (
      (job (unwrap! (map-get? jobs { job-id: job-id }) (err u404)))
    )
    (asserts! (is-eq (get client job) tx-sender) (err u403))
    (asserts! (is-eq (get status job) "open") (err u400))
    (map-set jobs
      { job-id: job-id }
      (merge job { status: "in-progress", freelancer: (some freelancer) })
    )
    (ok true)
  )
)

(define-public (complete-job (job-id uint))
  (let
    (
      (job (unwrap! (map-get? jobs { job-id: job-id }) (err u404)))
    )
    (asserts! (is-eq (get client job) tx-sender) (err u403))
    (asserts! (is-eq (get status job) "in-progress") (err u400))
    (map-set jobs
      { job-id: job-id }
      (merge job { status: "completed" })
    )
    (ok true)
  )
)

(define-read-only (get-job-details (job-id uint))
  (map-get? jobs { job-id: job-id })
)

