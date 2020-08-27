## Overall :
## - makeCacheMatrix create a list of functions to put some operations of an input matrix in cache
## - cacheSolve either takes the cache results or use the above function to make operations and put in cache

## Make a structure which is a functions vector which can :
## - put in cache the input matrix and the solved matrix result
## - get from the cache the input matrix and the solved matrix result

makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    set <- function(y) {
        x <<- y
        m <<- NULL
    }
    get <- function() x
    setsolve <- function(solve) m <<- solve
    getsolve <- function() m
    list(set = set, get = get,
         setsolve = setsolve,
         getsolve = getsolve)
}


## Get the solved matrix result in cache or solved it and put the result in cache

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    
    m <- x$getsolve()
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    data <- x$get()
    m <- solve(data, ...)
    x$setsolve(m)
    m
}