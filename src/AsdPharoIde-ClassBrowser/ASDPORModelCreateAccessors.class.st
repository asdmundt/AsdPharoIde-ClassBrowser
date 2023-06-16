Class {
	#name : #ASDPORModelCreateAccessors,
	#superclass : #ASDPORModelRefacturing,
	#category : #'AsdPharoIde-ClassBrowser-Model'
}

{ #category : #actions }
ASDPORModelCreateAccessors >> apllyingRefacturing [
	(RBAccessorClassRefactoring
		model: RBNamespace new
		className: self selClass name) execute
]

{ #category : #'private-class' }
ASDPORModelCreateAccessors >> classObjectFor: anObject [
	(anObject isBehavior or: [ anObject isTrait ])
		ifTrue: [ ^ self model classFor: anObject ].
	anObject isSymbol
		ifTrue: [ ^ self model classNamed: anObject ].
	^ anObject
]

{ #category : #initialization }
ASDPORModelCreateAccessors >> initialize [

	super initialize
	"self halt."
]
