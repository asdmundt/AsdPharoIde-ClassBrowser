Class {
	#name : #ASDPORModelCreateMaField,
	#superclass : #ASDPORModelRefacturing,
	#category : #'AsdPharoIde-ClassBrowser-Model'
}

{ #category : #actions }
ASDPORModelCreateMaField >> apllyingRefacturing [
	(RBAccessorClassRefactoring
		model: RBNamespace new
		className: self selClass name) execute
]

{ #category : #'private-class' }
ASDPORModelCreateMaField >> classObjectFor: anObject [
	(anObject isBehavior or: [ anObject isTrait ])
		ifTrue: [ ^ self model classFor: anObject ].
	anObject isSymbol
		ifTrue: [ ^ self model classNamed: anObject ].
	^ anObject
]

{ #category : #initialization }
ASDPORModelCreateMaField >> initialize [

	super initialize
	"self halt."
]
