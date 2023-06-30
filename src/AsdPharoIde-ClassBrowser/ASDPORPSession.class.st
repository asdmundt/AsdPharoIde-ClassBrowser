Class {
	#name : #ASDPORPSession,
	#superclass : #WASession,
	#instVars : [
		'currentUser',
		'rootComponent',
		'task',
		'model',
		'first',
		'loginError',
		'classBrowser'
	],
	#category : #'AsdPharoIde-ClassBrowser-Utils'
}

{ #category : #accessing }
ASDPORPSession >> classBrowser [

	^ classBrowser
]

{ #category : #accessing }
ASDPORPSession >> classBrowser: anObject [

	classBrowser := anObject
]

{ #category : #accessing }
ASDPORPSession >> currentUser [
	^ currentUser
]

{ #category : #accessing }
ASDPORPSession >> currentUser: anObject [
	currentUser := anObject
]

{ #category : #accessing }
ASDPORPSession >> first [
	^ first
]

{ #category : #accessing }
ASDPORPSession >> first: anObject [
	first := anObject
]

{ #category : #initialize }
ASDPORPSession >> initialize [
	super initialize.
	self model: ASDPORPlanung current.
]

{ #category : #testing }
ASDPORPSession >> isLogged [
	^ self currentUser notNil
]

{ #category : #accessing }
ASDPORPSession >> loginError [
	^ loginError
]

{ #category : #accessing }
ASDPORPSession >> loginError: anObject [
	loginError := anObject
]

{ #category : #accessing }
ASDPORPSession >> model [
	^ model
]

{ #category : #accessing }
ASDPORPSession >> model: anObject [
	model := anObject
]

{ #category : #operations }
ASDPORPSession >> reset [
	currentUser := nil.
	self requestContext redirectTo: self application url.
	self unregister
]

{ #category : #operations }
ASDPORPSession >> resetStates [

]

{ #category : #accessing }
ASDPORPSession >> rootComponent [
	^ rootComponent
]

{ #category : #accessing }
ASDPORPSession >> rootComponent: aRootComponent [
	rootComponent := aRootComponent
]
