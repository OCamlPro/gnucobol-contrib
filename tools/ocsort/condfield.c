/*
 *  Copyright (C) 2009 Cedric ISSALY
 *
 *	This file is part of OCSort.
 *
 *  OCSort is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  OCSort is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with OCSort.  If not, see <http://www.gnu.org/licenses/>.

*/

#include <stdio.h>
#include <stdlib.h>
#include "condfield.h"
#include "ocsort.h"
#include "utils.h"
#include "fieldvalue.h"

#define COND_TYPE_OPERATION		0
#define COND_TYPE_CONDITION		1
#define COND_TYPE_PARENTHESIS	2

struct condField_t {
	int type;
	union {
		struct {
			int operation;
			struct condField_t *first;
			struct condField_t *second;
		} operation;
		struct {
			int position;
			int length;
			int type;
			int condition;
			struct fieldValue_t *fieldValue;
		} condition;
	};
	struct condField_t *next;
};


struct condField_t *condField_constructor_condition(int position, int length, int type, int condition, struct fieldValue_t *fieldValue) {
	struct condField_t *condField=(struct condField_t *)malloc(sizeof(struct condField_t));
	condField->type=COND_TYPE_CONDITION;
	condField->condition.position=position;
	condField->condition.length=length;
	condField->condition.type=type;
	condField->condition.condition=condition;
	condField->condition.fieldValue=fieldValue;

	return condField;

}
struct condField_t *condField_constructor_operation(int operation, struct condField_t *first, struct condField_t *second) {
	struct condField_t *condField=(struct condField_t *)malloc(sizeof(struct condField_t));
	condField->type=COND_TYPE_OPERATION;
	condField->operation.operation=operation;
	condField->operation.first=first;
	condField->operation.second=second;
	return condField;
}

void condField_destructor(struct condField_t *condField) {
	free(condField);
}


int condField_print(struct condField_t *condField) {
	switch (condField->type) {
		case COND_TYPE_CONDITION:
			printf("%d,%d,%s,%s,",
					condField->condition.position,
					condField->condition.length,
					utils_getFieldTypeName(condField->condition.type),
					utils_getCondConditionName(condField->condition.condition));
			fieldValue_print(condField->condition.fieldValue);
			break;
		case COND_TYPE_OPERATION:
			printf("(");
			condField_print(condField->operation.first);
			printf(",%s,",utils_getCondOperationName(condField->operation.operation));
			condField_print(condField->operation.second);
			printf(")");
			break;
		default:
			break;
	}
	return 0;
}

int condField_test(struct condField_t *condField, char *record) {
	int result;
	switch (condField->type) {
		case COND_TYPE_CONDITION:
			result=fieldValue_test(condField->condition.fieldValue, record+condField->condition.position,condField->condition.length);
			switch (condField->condition.condition) {
				case COND_CONDITION_EQUAL:
					return (result==0);
				case COND_CONDITION_GREATERTHAN:
					return (result<0);
				case COND_CONDITION_GREATEREQUAL:
					return (result<=0);
				case COND_CONDITION_LESSERTHAN:
					return (result>0);
				case COND_CONDITION_LESSEREQUAL:
					return (result>=0);
				default:
					break;
			}
			break;
		case COND_TYPE_OPERATION:
			switch (condField->operation.operation) {
				case COND_OPERATION_AND:
					return (condField_test(condField->operation.first,record) && condField_test(condField->operation.second,record));
				case COND_OPERATION_OR:
					return (condField_test(condField->operation.first,record) || condField_test(condField->operation.second,record));
				default:
					break;
			}
			break;
		default:
			break;
	}
	return 0;
}
