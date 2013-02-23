//
//  MGTBXMLTraverser.m
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "MGTBXMLTraverser.h"

@interface MGTBXMLTraverser()
@property(nonatomic,retain) TBXMLSuccessBlock successBlock;
@property(nonatomic,retain) TBXMLFailureBlock failureBlock;
@property(nonatomic,retain) TBXML *tbxml;
@end

@implementation MGTBXMLTraverser
@synthesize tbxml = _tbxml;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        // Create a success block to be called when the async request completes
        _successBlock = ^(TBXML *tbxmlDocument) {
            // If TBXML found a root node, process element and iterate all children
            if (tbxmlDocument.rootXMLElement)
                [self traverseElement:tbxmlDocument.rootXMLElement];
        };
        
        // Create a failure block that gets called if something goes wrong
        _failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
            NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        };
    }
    return self;
}

- (void)ParseTBXML
{
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.wigtastic.com/MobGenImages/ImageManifest.xml"]
                                      success:_successBlock
                                      failure:_failureBlock];
}

- (void)loadUnknownXML {
    NSError *error = nil;
    
    // Load and parse the books.xml file
    _tbxml = [TBXML tbxmlWithXMLFile:@"books.xml" error:&error];
    
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // If TBXML found a root node, process element and iterate all children
        if (_tbxml.rootXMLElement)
            [self traverseElement:_tbxml.rootXMLElement];
    }
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
}
@end
