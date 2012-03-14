###
Copyright (c) 2012 [DeftJS Framework Contributors](http://deftjs.org)
Open source under the [MIT License](http://en.wikipedia.org/wiki/MIT_License).
###

###
Jasmine test suite for Deft.util.Deferred
###
describe( 'Deft.util.Deferred', ->
	
	beforeEach( ->
		@addMatchers(
			toBeInstanceOf: ( className ) ->
				return @actual instanceof Ext.ClassManager.get( className )
		)
		
		return
	)
	
	describe( 'State Flow and Completion', ->
		
		deferred = null
		successCallback = failureCallback = progressCallback = cancelCallback = null
		
		beforeEach( ->
			deferred = Ext.create( 'Deft.util.Deferred' )
			
			successCallback  = jasmine.createSpy()
			failureCallback  = jasmine.createSpy()
			progressCallback = jasmine.createSpy()
			cancelCallback   = jasmine.createSpy()
			
			return
		)
		
		it( 'should allow access to the associated Promise', ->
			expect( deferred.getPromise() ).toBeInstanceOf( 'Deft.util.Promise' )
			
			return
		)
		
		it( 'should resolve', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.resolve( 'expected value' )
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).toHaveBeenCalledWith( 'expected value' )
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should reject', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.reject( 'error message' )
			expect( deferred.getState() ).toBe( 'rejected' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).toHaveBeenCalledWith( 'error message' )
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should update', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.update( 'progress' )
			expect( deferred.getState() ).toBe( 'pending' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).toHaveBeenCalledWith( 'progress' )
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should cancel', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.cancel( 'reason' )
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).toHaveBeenCalledWith( 'reason' )
			
			return
		)
		
		it( 'should allow resolution after update', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.update( 'progress' )
			expect( deferred.getState() ).toBe( 'pending' )
			
			deferred.resolve( 'expected value' )
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).toHaveBeenCalledWith( 'expected value' )
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).toHaveBeenCalledWith( 'progress' )
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should allow rejection after update', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.update( 'progress' )
			expect( deferred.getState() ).toBe( 'pending' )
			
			deferred.reject( 'error message' )
			expect( deferred.getState() ).toBe( 'rejected' )
			
			return
		)
		
		it( 'should allow cancellation after update', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.update( 'progress' )
			expect( deferred.getState() ).toBe( 'pending' )
				
			deferred.cancel( 'reason' )
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			return
		)
		
		it( 'should not allow resolution after resolution', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.resolve( 'expected value' )
			
			successCallback.reset() if successCallback?
			
			expect( ->
				deferred.resolve( 'expected value' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow rejection after resolution', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.resolve( 'expected value' )
			
			successCallback.reset() if successCallback?
			
			expect( ->
				deferred.reject( 'error message' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow update after resolution', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.resolve( 'expected value' )
			
			successCallback.reset() if successCallback?
			
			expect( ->
				deferred.update( 'progress' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow cancellation after resolution', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.resolve( 'expected value' )
			
			successCallback.reset() if successCallback?
			
			expect( ->
				deferred.cancel( 'reason' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'resolved' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow resolution after rejection', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.reject( 'error message' )
			
			failureCallback.reset() if failureCallback?
			
			expect( ->
				deferred.resolve( 'expected value' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'rejected' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow rejection after rejection', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.reject( 'error message' )
			
			failureCallback.reset() if failureCallback?
			
			expect( ->
				deferred.reject( 'error message' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'rejected' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow update after rejection', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.reject( 'error message' )
			
			failureCallback.reset() if failureCallback?
			
			expect( ->
				deferred.update( 'progress' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'rejected' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow cancellation after rejection', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.reject( 'error message' )
			
			failureCallback.reset() if failureCallback?
			
			expect( ->
				deferred.cancel( 'reason' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'rejected' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow resolution after cancellation', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.cancel( 'reason' )
			
			cancelCallback.reset() if cancelCallback?
			
			expect( ->
				deferred.resolve( 'expected value' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow rejection after cancellation', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.cancel( 'reason' )
			
			cancelCallback.reset() if cancelCallback?
			
			expect( ->
				deferred.reject( 'error message' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow update after cancellation', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.cancel( 'reason' )
			
			cancelCallback.reset()
			
			expect( ->
				deferred.update( 'progress' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should not allow cancellation after cancellation', ->
			deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			deferred.cancel( 'reason' )
			
			cancelCallback.reset() if cancelCallback?
			
			expect( ->
				deferred.cancel( 'reason' )
				return
			).toThrow( new Error( 'Error: this Deferred has already been completed and cannot be modified.' ) )
			
			expect( deferred.getState() ).toBe( 'cancelled' )
			
			expect( successCallback ).not.toHaveBeenCalled()
			expect( failureCallback ).not.toHaveBeenCalled()
			expect( progressCallback ).not.toHaveBeenCalled()
			expect( cancelCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		return
	)
	
	describe( 'Callback registration via then()', ->
		
		createSpecsForThen = ( thenFunction, callbacksFactoryFunction ) ->
			
			deferred = null
			successCallback = failureCallback = progressCallback = cancelCallback = null
			
			beforeEach( ->
				deferred = Ext.create( 'Deft.util.Deferred' )
				
				{ success: successCallback, failure: failureCallback, progress: progressCallback, cancel: cancelCallback } = callbacksFactoryFunction()
				
				return
			)
			
			it( 'should call success callback (if specified) when resolved', ->
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				deferred.resolve( 'expected value' )
				
				expect( successCallback ).toHaveBeenCalledWith( 'expected value' ) if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should call failure callback (if specified) when rejected', ->
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				deferred.reject( 'error message' )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).toHaveBeenCalledWith( 'error message' ) if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should call progress callback (if specified) when updated', ->
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				deferred.update( 'progress' )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).toHaveBeenCalledWith( 'progress' ) if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should call cancel callback (if specified) when cancelled', ->
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				deferred.cancel( 'reason' )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).toHaveBeenCalledWith( 'reason' ) if cancelCallback?
				
				return
			)
			
			it( 'should immediately call newly added success callback (if specified) when already resolved', ->
				deferred.resolve( 'expected value' )
				
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				expect( successCallback ).toHaveBeenCalledWith( 'expected value' ) if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should immediately call newly added failure callback (if specified) when already rejected', ->
				deferred.reject( 'error message' )
				
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).toHaveBeenCalledWith( 'error message' ) if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should immediately call newly added progress callback (if specified) when already updated', ->
				deferred.update( 'progress' )
				
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).toHaveBeenCalledWith( 'progress' ) if progressCallback?
				expect( cancelCallback ).not.toHaveBeenCalled() if cancelCallback?
				
				return
			)
			
			it( 'should immediately call newly added cancel callback (if specified) when already cancelled', ->
				deferred.cancel( 'reason' )
				
				thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				expect( successCallback ).not.toHaveBeenCalled() if successCallback?
				expect( failureCallback ).not.toHaveBeenCalled() if failureCallback?
				expect( progressCallback ).not.toHaveBeenCalled() if progressCallback?
				expect( cancelCallback ).toHaveBeenCalledWith( 'reason' ) if cancelCallback?
				
				return
			)
			
			it( 'should throw an error when non-function callback(s) are specified', ->
				if successCallback or failureCallback or progressCallback or cancelCallback
					expect( ->
						thenFunction( 
							deferred
							if successCallback  then 'value' else successCallback
							if failureCallback  then 'value' else failureCallback
							if progressCallback then 'value' else progressCallback
							if cancelCallback   then 'value' else cancelCallback
						)
						
						return
					).toThrow( new Error( 'Error while configuring callback: a non-function specified.' ) )
			)
			
			it( 'should return a new Promise', ->
				result = thenFunction( deferred, successCallback, failureCallback, progressCallback, cancelCallback )
				
				expect( result ).toBeInstanceOf( 'Deft.util.Promise' )
				expect( result ).not.toBe( deferred.promise )
				
				return
			)
			
			return
		
		describe( 'with callbacks specified via method parameters', ->
			
			thenFunction = ( deferred, successCallback, failureCallback, progressCallback, cancelCallback ) ->
				deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			callbacksFactoryFunction = ->
				{
					success: jasmine.createSpy()
					failure: jasmine.createSpy()
					progress: jasmine.createSpy()
					cancel: jasmine.createSpy()
				}
			
			createSpecsForThen( thenFunction, callbacksFactoryFunction )
			
			return
		)
		
		describe( 'with callbacks specified via method parameters,', ->
			
			thenFunction = ( deferred, successCallback, failureCallback, progressCallback, cancelCallback ) ->
				deferred.then( successCallback, failureCallback, progressCallback, cancelCallback )
			
			createCallbacksFactoryFunction = ( index, valueWhenOmitted ) ->
				callbacksFactoryFunction = ->
					callbacks = {}
					
					callbacks.success  = if index is 0 then jasmine.createSpy() else valueWhenOmitted
					callbacks.failure  = if index is 1 then jasmine.createSpy() else valueWhenOmitted
					callbacks.progress = if index is 2 then jasmine.createSpy() else valueWhenOmitted
					callbacks.cancel   = if index is 3 then jasmine.createSpy() else valueWhenOmitted
				
					return callbacks
				
				return callbacksFactoryFunction
			
			callbackNames = [ 'success', 'failure', 'progress', 'cancel' ]
			for index in [ 0..3 ]
				describe( "omitting #{ callbackNames[ index ] } callback as null", ->
					createSpecsForThen( thenFunction, createCallbacksFactoryFunction( index, null ) )
					return
				)
				describe( "omitting #{ callbackNames[ index ] } callback as undefined", ->
					createSpecsForThen( thenFunction, createCallbacksFactoryFunction( index, undefined ) )
					return
				)
			
			return
		)
		
		describe( 'with callbacks specified via configuration Object', ->
			
			thenFunction = ( deferred, successCallback, failureCallback, progressCallback, cancelCallback ) ->
					deferred.then( 
						success: successCallback
						failure: failureCallback
						progress: progressCallback
						cancel: cancelCallback
					)
			
			callbacksFactoryFunction = ->
				{
					success: jasmine.createSpy()
					failure: jasmine.createSpy()
					progress: jasmine.createSpy()
					cancel: jasmine.createSpy()
				}
			
			createSpecsForThen( thenFunction, callbacksFactoryFunction )
			
			return
		)
		
		describe( 'with callbacks specified via configuration Object,', ->
			
			thenFunction = ( deferred, successCallback, failureCallback, progressCallback, cancelCallback ) ->
					deferred.then( 
						success: successCallback
						failure: failureCallback
						progress: progressCallback
						cancel: cancelCallback
					)
			
			createCallbacksFactoryFunction = ( index, valueWhenOmitted ) ->
				callbacksFactoryFunction = ->
					callbacks = {}
					
					callbacks.success  = if index is 0 then jasmine.createSpy() else valueWhenOmitted
					callbacks.failure  = if index is 1 then jasmine.createSpy() else valueWhenOmitted
					callbacks.progress = if index is 2 then jasmine.createSpy() else valueWhenOmitted
					callbacks.cancel   = if index is 3 then jasmine.createSpy() else valueWhenOmitted
					
					return callbacks
				
				return callbacksFactoryFunction
			
			callbackNames = [ 'success', 'failure', 'progress', 'cancel' ]
			for index in [ 0..3 ]
				describe( "omitting #{ callbackNames[ index ] } callback as null", ->
					createSpecsForThen( thenFunction, createCallbacksFactoryFunction( index, null ) )
					return
				)
				
				describe( "omitting #{ callbackNames[ index ] } callback as undefined", ->
					createSpecsForThen( thenFunction, createCallbacksFactoryFunction( index, undefined ) )
					return
				)
				
			return
		)
	)
	
	describe( 'Callback registration via always()', ->
		
		deferred = null
		alwaysCallback = null
		
		beforeEach( ->
			deferred = Ext.create( 'Deft.util.Deferred' )
			
			alwaysCallback = jasmine.createSpy()
			
			return
		)
		
		it( 'should call always callback when resolved', ->
			deferred.always( alwaysCallback )
			
			deferred.resolve( 'expected value' )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should call always callback when rejected', ->
			deferred.always( alwaysCallback )
			
			deferred.reject( 'error message' )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should not call always callback when updated', ->
			deferred.always( alwaysCallback )
			
			deferred.update( 'progress' )
			
			expect( alwaysCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should call always callback when cancelled', ->
			deferred.always( alwaysCallback )
			
			deferred.cancel( 'reason' )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should immediately call always callback when already resolved', ->
			deferred.resolve( 'expected value' )
			
			deferred.always( alwaysCallback )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should immediately call always callback when already rejected', ->
			deferred.reject( 'error message' )
			
			deferred.always( alwaysCallback )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should not immediately call always callback when already updated', ->
			deferred.update( 'progress' )
			
			deferred.always( alwaysCallback )
			
			expect( alwaysCallback ).not.toHaveBeenCalled()
			
			return
		)
		
		it( 'should immediately call always callback when already cancelled', ->
			deferred.cancel( 'reason' )
			
			deferred.always( alwaysCallback )
			
			expect( alwaysCallback ).toHaveBeenCalled()
			
			return
		)
		
		it( 'should allow a null callback to be specified', ->
			expect( ->
				deferred.always( null )
				return
			).not.toThrow()
			
			return
		)
		
		it( 'should allow an undefined callback to be specified', ->
			expect( ->
				deferred.always( undefined )
				return
			).not.toThrow()
			
			return
		)
		
		it( 'should throw an error when a non-function callback is specified', ->
			expect( ->
				deferred.always( 'value' )
				return
			).toThrow( new Error( 'Error while configuring callback: a non-function specified.' ) )
			
			return
		)
		
		it( 'should return a new Promise', ->
			result = deferred.always( alwaysCallback )
			
			expect( result ).toBeInstanceOf( 'Deft.util.Promise' )
			expect( result ).not.toBe( deferred.promise )
			
			return
		)
		
		it( 'should return a new Promise when a null callback is specified', ->
			result = deferred.always( null )
			
			expect( result ).toBeInstanceOf( 'Deft.util.Promise' )
			expect( result ).not.toBe( deferred.promise )
			
			return
		)
		
		it( 'should return a new Promise when an undefined callback is specified', ->
			result = deferred.always( undefined )
			
			expect( result ).toBeInstanceOf( 'Deft.util.Promise' )
			expect( result ).not.toBe( deferred.promise )
			
			return
		)
	)
)