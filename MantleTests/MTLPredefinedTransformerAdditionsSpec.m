//
//  MTLPredefinedTransformerAdditionsSpec.m
//  Mantle
//
//  Created by Justin Spahr-Summers on 2012-09-27.
//  Copyright (c) 2012 GitHub. All rights reserved.
//

#import "MTLTestModel.h"

SpecBegin(MTLPredefinedTransformerAdditions)

it(@"should define a URL value transformer", ^{
	NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
	expect(transformer).notTo.beNil();
	expect([transformer.class allowsReverseTransformation]).to.beTruthy();

	NSString *URLString = @"http://www.github.com/";
	expect([transformer transformedValue:URLString]).to.equal([NSURL URLWithString:URLString]);
	expect([transformer reverseTransformedValue:[NSURL URLWithString:URLString]]).to.equal(URLString);

	expect([transformer transformedValue:nil]).to.beNil();
	expect([transformer reverseTransformedValue:nil]).to.beNil();
});

it(@"should define an NSNumber boolean value transformer", ^{
	// Back these NSNumbers with ints, rather than booleans,
	// to ensure that the value transformers are actually transforming.
	NSNumber *booleanYES = @(1);
	NSNumber *booleanNO = @(0);

	NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
	expect(transformer).notTo.beNil();
	expect([transformer.class allowsReverseTransformation]).to.beTruthy();

	expect([transformer transformedValue:booleanYES]).to.equal([NSNumber numberWithBool:YES]);
	expect([transformer transformedValue:booleanYES]).to.equal((id)kCFBooleanTrue);

	expect([transformer reverseTransformedValue:booleanYES]).to.equal([NSNumber numberWithBool:YES]);
	expect([transformer reverseTransformedValue:booleanYES]).to.equal((id)kCFBooleanTrue);

	expect([transformer transformedValue:booleanNO]).to.equal([NSNumber numberWithBool:NO]);
	expect([transformer transformedValue:booleanNO]).to.equal((id)kCFBooleanFalse);

	expect([transformer reverseTransformedValue:booleanNO]).to.equal([NSNumber numberWithBool:NO]);
	expect([transformer reverseTransformedValue:booleanNO]).to.equal((id)kCFBooleanFalse);

	expect([transformer transformedValue:nil]).to.beNil();
	expect([transformer reverseTransformedValue:nil]).to.beNil();
});

describe(@"JSON transformer", ^{
	__block MTLNewTestModel *model;
	__block NSValueTransformer *transformer;

	before(^{
		model = [[MTLNewTestModel alloc] init];
		expect(model).notTo.beNil();

		transformer = [NSValueTransformer mtl_JSONTransformerWithModelClass:model.class];
		expect(transformer).notTo.beNil();
	});

	it(@"should transform JSON into a model", ^{
		expect([transformer transformedValue:[model externalRepresentationInFormat:MTLModelJSONFormat]]).to.equal(model);
	});

	it(@"should transform a model into JSON", ^{
		expect([transformer.class allowsReverseTransformation]).to.beTruthy();
		expect([transformer reverseTransformedValue:model]).to.equal([model externalRepresentationInFormat:MTLModelJSONFormat]);
	});
});

describe(@"JSON array transformer", ^{
	__block NSArray *models;
	__block NSArray *JSONDictionaries;
	__block NSValueTransformer *transformer;

	before(^{
		NSMutableArray *uniqueModels = [NSMutableArray array];
		for (NSUInteger i = 0; i < 10; i++) {
			MTLNewTestModel *model = [[MTLNewTestModel alloc] init];
			model.count = i;

			[uniqueModels addObject:model];
		}

		models = [uniqueModels copy];
		JSONDictionaries = [uniqueModels mtl_mapUsingBlock:^(MTLNewTestModel *model) {
			return [model externalRepresentationInFormat:MTLModelJSONFormat];
		}];

		expect(models).notTo.beNil();
		expect(JSONDictionaries).notTo.beNil();

		transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MTLNewTestModel.class];
		expect(transformer).notTo.beNil();
	});

	it(@"should transform JSON dictionaries into models", ^{
		expect([transformer transformedValue:JSONDictionaries]).to.equal(models);
	});

	it(@"should transform models into JSON dictionaries", ^{
		expect([transformer.class allowsReverseTransformation]).to.beTruthy();
		expect([transformer reverseTransformedValue:models]).to.equal(JSONDictionaries);
	});
});

SpecEnd
