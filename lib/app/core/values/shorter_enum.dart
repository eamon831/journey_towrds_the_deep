import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Equivalents to TextInputType.text
/// Used for text input
const textInputType = TextInputType.text;

/// Equivalents to TextInputType.number
/// Used for number input
const numberInputType = TextInputType.number;

/// Equivalents to TextInputType.datetime
/// Used for date and time input
const datetimeInputType = TextInputType.datetime;

/// Equivalents to TextInputType.phone
/// Used for phone number input
const phoneInputType = TextInputType.phone;

/// Equivalents to TextInputType.emailAddress
/// Used for email input
const emailAddressInputType = TextInputType.emailAddress;

/// Equivalents to TextInputType.url
/// Used for URL input
const multilineInputType = TextInputType.multiline;

/// Equivalents to TextInputType.numberWithOptions
/// Used for number input with options
//final  numberWithOptionsInputType = TextInputType.numberWithOptions;

//TextInputAction enums
/// Equivalents to TextInputAction.done
/// Used for done action
const doneInputAction = TextInputAction.done;

/// Equivalents to TextInputAction.next
/// Used for next action
const nextInputAction = TextInputAction.next;

/// Equivalents to TextInputAction.previous
/// Used for previous action
const previousInputAction = TextInputAction.previous;

/// Equivalents to TextInputAction.search
/// Used for search action
const searchInputAction = TextInputAction.search;

/// Equivalents to TextInputAction.go
/// Used for go action
const goInputAction = TextInputAction.go;

/// Equivalents to TextInputAction.send
/// Used for send action
const sendInputAction = TextInputAction.send;

/// Equivalents to TextInputAction.none
/// Used for no action
const noneInputAction = TextInputAction.none;

//Validation enums

/// Equivalents to AutoValidateMode.always
/// Used for always auto validation
const autoValidate = AutovalidateMode.always;

/// Equivalents to AutoValidateMode.onUserInteraction
/// Used for auto validation on user interaction
const onUserInteraction = AutovalidateMode.onUserInteraction;

/// Equivalents to AutoValidateMode.disabled
/// Used for disabled auto validation
const disabled = AutovalidateMode.disabled;

//InputFormatters enums

final integerInputFormatter = [
  FilteringTextInputFormatter.allow(
    RegExp('^[0-9]*'),
  ),
];
final doubleInputFormatter = [
  FilteringTextInputFormatter.allow(
    RegExp(r'^[0-9]*\.?[0-9]*'),
  ),
];
// MainAxisAlignment enums

/// Equivalents to MainAxisAlignment.start
/// Aligns widgets at the start of the main axis
const startMAA = MainAxisAlignment.start;

///Equivalents to MainAxisAlignment.end
/// Aligns widgets at the end of the main axis
const endMAA = MainAxisAlignment.end;

/// Equivalents to MainAxisAlignment.center
/// Aligns widgets at the center of the main axis
const centerMAA = MainAxisAlignment.center;

/// Equivalents to MainAxisAlignment.spaceBetween
/// Spaces widgets evenly along the main axis, distributing any extra space
/// between the widgets
const spaceBetweenMAA = MainAxisAlignment.spaceBetween;

/// Equivalents to MainAxisAlignment.spaceAround
/// Spaces widgets evenly along the main axis, distributing any extra space
/// around the widgets
const spaceAroundMAA = MainAxisAlignment.spaceAround;

/// Equivalents to MainAxisAlignment.spaceEvenly
/// Spaces widgets evenly along the main axis, including extra space before
/// the first widget and after the last widget
const spaceEvenlyMAA = MainAxisAlignment.spaceEvenly;

//CrossAxisAlignment enums
/// Equivalents to CrossAxisAlignment.start
/// Aligns children to the start of the cross axis
const startCAA = CrossAxisAlignment.start;

/// Equivalents to CrossAxisAlignment.end
/// Aligns children to the end of the cross axis
const endCAA = CrossAxisAlignment.end;

/// Equivalents to CrossAxisAlignment.center
/// Aligns children to the center of the cross axis
const centerCAA = CrossAxisAlignment.center;

/// Equivalents to CrossAxisAlignment.stretch
/// Aligns children to fill the cross axis
const stretchCAA = CrossAxisAlignment.stretch;

/// Equivalents to CrossAxisAlignment.baseline
/// Aligns children according to their baseline
const baselineCAA = CrossAxisAlignment.baseline;

//MainAxisSize enums

/// Equivalents to MainAxisSize.min
/// The minimum size a widget can be
const minMAS = MainAxisSize.min;

/// Equivalents to MainAxisSize.max
/// The maximum size a widget can be
const maxMAS = MainAxisSize.max;

//TextAlign enums
const leftTA = TextAlign.left;
const rightTA = TextAlign.right;
const centerTA = TextAlign.center;
const justifyTA = TextAlign.justify;
const startTA = TextAlign.start;
const endTA = TextAlign.end;

//TextDirection enums
const trTD = TextDirection.ltr;
const rtlTD = TextDirection.rtl;

//TextOverflow enums
const clipTO = TextOverflow.clip;
const fadeTO = TextOverflow.fade;
const ellipsisTO = TextOverflow.ellipsis;
const visibleTO = TextOverflow.visible;

//WrapAlignment enums
const startWA = WrapAlignment.start;
const endWA = WrapAlignment.end;
const centerWA = WrapAlignment.center;
const spaceBetweenWA = WrapAlignment.spaceBetween;
const spaceAroundWA = WrapAlignment.spaceAround;
const spaceEvenlyWA = WrapAlignment.spaceEvenly;

//WrapCrossAlignment enums
const startWCA = WrapCrossAlignment.start;
const endWCA = WrapCrossAlignment.end;
const centerWCA = WrapCrossAlignment.center;

const zero = EdgeInsets.zero;
