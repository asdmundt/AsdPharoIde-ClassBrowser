Class {
	#name : #ASDPORPSession,
	#superclass : #WASession,
	#instVars : [
		'currentUser',
		'rootComponent',
		'task',
		'model',
		'first',
		'loginError'
	],
	#category : #'AsdPharoIde-ClassBrowser-Utils'
}

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

{ #category : #'as yet unclassified' }
ASDPORPSession >> rootComponent [
	^ rootComponent
]

{ #category : #'as yet unclassified' }
ASDPORPSession >> rootComponent: aRootComponent [
	rootComponent := aRootComponent
]
