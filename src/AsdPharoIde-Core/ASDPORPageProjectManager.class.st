Class {
	#name : #ASDPORPageProjectManager,
	#superclass : #ASDPORComponent,
	#category : #'AsdPharoIde-Core-Core'
}

{ #category : #testing }
ASDPORPageProjectManager class >> isAbstract [
	^ self = ASDPORPageModules
]

{ #category : #accessing }
ASDPORPageProjectManager class >> pageName [
	"Title of the page that will be used in menus and URLs."

	^ self subclassResponsibility
]

{ #category : #accessing }
ASDPORPageProjectManager class >> pagesToDisplay [
	^ (self allSubclasses reject: #isAbstract) sorted: #priority ascending
]

{ #category : #accessing }
ASDPORPageProjectManager class >> pathName [
	"Use to define the URL name"

	^ self pageName copyWithout: $  
]

{ #category : #accessing }
ASDPORPageProjectManager class >> priority [
	^ self subclassResponsibility
]

{ #category : #accessing }
ASDPORPageProjectManager >> pathName [
	^ self class pathName
]
