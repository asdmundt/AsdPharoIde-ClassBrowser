Class {
	#name : #ASDPORPackageComponent,
	#superclass : #WAComponent,
	#instVars : [
		'oldName',
		'NewName',
		'action'
	],
	#category : #'AsdPharoIde-ClassBrowser-Component'
}

{ #category : #'instance creation' }
ASDPORPackageComponent class >> withAction: anObject [

	^ self new
		  action: anObject;
		  yourself

	
]

{ #category : #accessing }
ASDPORPackageComponent >> action [

	^ action
]

{ #category : #accessing }
ASDPORPackageComponent >> action: anObject [

	action := anObject
]

{ #category : #initialization }
ASDPORPackageComponent >> initialize [

	super initialize.
	self action: 'remane'.
	
]

{ #category : #accessing }
ASDPORPackageComponent >> newName [

	^ NewName
]

{ #category : #accessing }
ASDPORPackageComponent >> newName: anObject [

	NewName := anObject
]

{ #category : #accessing }
ASDPORPackageComponent >> oldName [

	^ oldName
]

{ #category : #accessing }
ASDPORPackageComponent >> oldName: anObject [

	oldName := anObject
]

{ #category : #actions }
ASDPORPackageComponent >> rename [


]

{ #category : #rendering }
ASDPORPackageComponent >> renderContentOn: html [

	
	html form: [ 
			html mdlTextFieldContainer
				floatingLabel;
				with: [ 
					html mdlTextFieldLabel
						for: html nextId;
						with: 'Name'.
					html mdlTextFieldInput
						id: html lastId;
						callback: [ :input | NewName := input ]
					]
			
						html mdlButton
				beSubmit;
				callback: [  ];
				with: 'Accept'.
			html mdlButton with: 'Cancel' 
			]
]
