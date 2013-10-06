//
//  UIFont+Replacement.m
//  FontReplacer
//
//  Created by Cédric Luthi on 2011-08-08.
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import "UIFont+Replacement7.h"
#import <objc/runtime.h>

@implementation UIFont (Replacement7)

static NSDictionary *replacementDictionary7 = nil;

static void initializeReplacementFonts7()
{
	if (replacementDictionary7)
		return;
    
	NSDictionary *replacementDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ReplacementFonts"];
	[UIFont setReplacementDictionary7:replacementDictionary];
}

+ (void) load7
{
	Method fontWithName_size_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:));
	Method fontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(fontWithName:size:traits:));
    Method fontWithDescriptor_size_ = class_getClassMethod([UIFont class], @selector(fontWithDescriptor:size:));
    
	Method replacementFontWithName_size_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:));
	Method replacementFontWithName_size_traits_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithName:size:traits:));
	Method replacementFontWithDescriptor_size_ = class_getClassMethod([UIFont class], @selector(replacement_fontWithDescriptor:size:));
    
	if (fontWithName_size_ && replacementFontWithName_size_ && strcmp(method_getTypeEncoding(fontWithName_size_), method_getTypeEncoding(replacementFontWithName_size_)) == 0)
		method_exchangeImplementations(fontWithName_size_, replacementFontWithName_size_);
	if (fontWithName_size_traits_ && replacementFontWithName_size_traits_ && strcmp(method_getTypeEncoding(fontWithName_size_traits_), method_getTypeEncoding(replacementFontWithName_size_traits_)) == 0)
		method_exchangeImplementations(fontWithName_size_traits_, replacementFontWithName_size_traits_);
    if (fontWithDescriptor_size_ && replacementFontWithDescriptor_size_ && strcmp(method_getTypeEncoding(fontWithDescriptor_size_), method_getTypeEncoding(replacementFontWithDescriptor_size_)) == 0){
        method_exchangeImplementations(fontWithDescriptor_size_, replacementFontWithDescriptor_size_);
    }
}

+ (UIFont *) replacement_fontWithName7:(NSString *)fontName size:(CGFloat)fontSize
{
	initializeReplacementFonts7();
	NSString *replacementFontName = [replacementDictionary7 objectForKey:fontName];
	return [self replacement_fontWithName7:replacementFontName ?: fontName size:fontSize];
}

+ (UIFont *) replacement_fontWithName7:(NSString *)fontName size:(CGFloat)fontSize traits:(int)traits
{
	initializeReplacementFonts7();
	NSString *replacementFontName = [replacementDictionary7 objectForKey:fontName];
	return [self replacement_fontWithName7:replacementFontName ?: fontName size:fontSize traits:traits];
}

+ (UIFont *) replacement_fontWithDescriptor7:(UIFontDescriptor*)descriptor size:(CGFloat)fontSize{
    initializeReplacementFonts7();
	NSString *replacementFontName = [replacementDictionary7 objectForKey:[descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute]];
    return [self replacement_fontWithDescriptor7:[UIFontDescriptor fontDescriptorWithName:replacementFontName ?: [descriptor.fontAttributes objectForKey:UIFontDescriptorNameAttribute] size:fontSize] size:fontSize];
}

+ (NSDictionary *) replacementDictionary7
{
	return replacementDictionary7;
}

+ (void) setReplacementDictionary7:(NSDictionary *)aReplacementDictionary
{
	if (aReplacementDictionary == replacementDictionary7)
		return;
    
	for (id key in [aReplacementDictionary allKeys])
	{
		if (![key isKindOfClass:[NSString class]])
		{
			NSLog(@"ERROR: Replacement font key must be a string.");
			return;
		}
        
		id value = [aReplacementDictionary valueForKey:key];
		if (![value isKindOfClass:[NSString class]])
		{
			NSLog(@"ERROR: Replacement font value must be a string.");
			return;
		}
	}
    
	[replacementDictionary7 release];
	replacementDictionary7 = [aReplacementDictionary retain];
    
	for (id key in [replacementDictionary7 allKeys])
	{
		NSString *fontName = [replacementDictionary7 objectForKey:key];
		UIFont *font = [UIFont fontWithName:fontName size:10];
		if (!font)
			NSLog(@"WARNING: replacement font '%@' is not available.", fontName);
	}
}

@end