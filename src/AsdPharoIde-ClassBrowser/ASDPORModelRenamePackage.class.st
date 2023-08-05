Class {
	#name : #ASDPORModelRenamePackage,
	#superclass : #ASDPORModelRefacturing,
	#category : #'AsdPharoIde-ClassBrowser-Model'
}

{ #category : #actions }
ASDPORModelRenamePackage >> apllyingRefacturing [
	(RBAccessorClassRefactoring
		model: RBNamespace new
		className: self selClass name) execute
]

{ #category : #'private-class' }
ASDPORModelRenamePackage >> classObjectFor: anObject [
	(anObject isBehavior or: [ anObject isTrait ])
		ifTrue: [ ^ self model classFor: anObject ].
	anObject isSymbol
		ifTrue: [ ^ self model classNamed: anObject ].
	^ anObject
]

{ #category : #initialization }
ASDPORModelRenamePackage >> initialize [

	super initialize
	"self halt."
]
