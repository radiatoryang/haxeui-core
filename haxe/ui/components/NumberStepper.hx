package haxe.ui.components;

import haxe.ui.containers.HBox;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.DataBehaviour;
import haxe.ui.core.DefaultBehaviour;
import haxe.ui.core.FocusEvent;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.util.MathUtil;
import haxe.ui.util.Variant;

@:composite(Events, Builder)
class NumberStepper extends HBox {
    @:clonable @:behaviour(PosBehaviour, 0)             public var pos:Float;
    @:clonable @:behaviour(ValueBehaviour)              public var value:Variant;
    @:clonable @:behaviour(StepBehaviour, 1)            public var step:Float;
    @:clonable @:behaviour(MinBehaviour, null)          public var min:Null<Float>;
    @:clonable @:behaviour(MaxBehaviour, null)          public var max:Null<Float>;
    @:clonable @:behaviour(PrecisionBehaviour, null)    public var precision:Null<Int>;
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class PosBehaviour extends DataBehaviour {
    public override function validateData() {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        var preciseValue:Float = _value;
        if (step.precision != null) {
            preciseValue = MathUtil.round(preciseValue, step.precision);
        }

        step.pos = preciseValue;
        
        var textfield:TextField = _component.findComponent("stepper-textfield", TextField);
        textfield.text = Std.string(preciseValue);
        
        var event = new UIEvent(UIEvent.CHANGE);
        _component.dispatch(event);
    }
}

@:dox(hide) @:noCompletion
private class ValueBehaviour extends DefaultBehaviour {
    public override function get():Variant {
        var stepper:NumberStepper = cast(_component, NumberStepper);
        return stepper.pos;
    }
    
    public override function set(value:Variant) {
        var stepper:NumberStepper = cast(_component, NumberStepper);
        stepper.pos = value;
    }
}

@:dox(hide) @:noCompletion
private class StepBehaviour extends DefaultBehaviour {
    public override function get():Variant {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        return step.step;
    }
    
    public override function set(value:Variant) {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        step.step = value;
    }
}

@:dox(hide) @:noCompletion
private class MinBehaviour extends DefaultBehaviour {
    public override function get():Variant {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        return step.min;
    }
    
    public override function set(value:Variant) {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        step.min = value;
    }
}

@:dox(hide) @:noCompletion
private class MaxBehaviour extends DefaultBehaviour {
    public override function get():Variant {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        return step.max;
    }
    
    public override function set(value:Variant) {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        step.max = value;
    }
}

@:dox(hide) @:noCompletion
private class PrecisionBehaviour extends DefaultBehaviour {
    public override function get():Variant {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        return step.precision;
    }
    
    public override function set(value:Variant) {
        var step:Stepper = _component.findComponent("stepper-step", Stepper);
        step.precision = value;
    }
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Builder extends CompositeBuilder {
    private var _stepper:NumberStepper;
    
    public function new(stepper:NumberStepper) {
        super(stepper);
        _stepper = stepper;
    }
    
    public override function create() {
        _stepper.addClass("textfield");
        
        var textfield = new TextField();
        textfield.addClass("stepper-textfield");
        textfield.id = "stepper-textfield";
		textfield.restrictChars = "0-9.-";
        _stepper.addComponent(textfield);
        
        var step = new Stepper();
        step.addClass("stepper-step");
        step.id = "stepper-step";
        _stepper.addComponent(step);
    }
}


//***********************************************************************************************************
// Composite Events
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Events extends haxe.ui.core.Events {
    private var _stepper:NumberStepper;
    
    public function new(stepper:NumberStepper) {
        super(stepper);
        _stepper = stepper;
    }
    
    public override function register() {
        if (!hasEvent(MouseEvent.MOUSE_WHEEL, onMouseWheel)) {
            registerEvent(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        }
        
        var textfield:TextField = _stepper.findComponent("stepper-textfield", TextField);
        if (!textfield.hasEvent(FocusEvent.FOCUS_IN, onTextFieldFocusIn)) {
            textfield.registerEvent(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
        }
        if (!textfield.hasEvent(FocusEvent.FOCUS_OUT, onTextFieldFocusOut)) {
            textfield.registerEvent(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
        }
        if (!textfield.hasEvent(UIEvent.CHANGE, onTextFieldChange)) {
            textfield.registerEvent(UIEvent.CHANGE, onTextFieldChange);
        }
        
        var step:Stepper = _stepper.findComponent("stepper-step", Stepper);
        if (!step.hasEvent(UIEvent.CHANGE, onStepChange)) {
            step.registerEvent(UIEvent.CHANGE, onStepChange);
        }
        if (!step.hasEvent(MouseEvent.MOUSE_DOWN, onStepMouseDown)) {
            step.registerEvent(MouseEvent.MOUSE_DOWN, onStepMouseDown);
        }
    }
    
    public override function unregister() {
        unregisterEvent(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        
        var textfield:TextField = _stepper.findComponent("stepper-textfield", TextField);
        textfield.unregisterEvent(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
        textfield.unregisterEvent(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
        textfield.unregisterEvent(UIEvent.CHANGE, onTextFieldChange);
        
        var step:Stepper = _stepper.findComponent("stepper-step", Stepper);
        step.unregisterEvent(UIEvent.CHANGE, onStepChange);
        step.unregisterEvent(MouseEvent.MOUSE_DOWN, onStepMouseDown);
    }
    
    private function onMouseWheel(event:MouseEvent) {
        var textfield:TextField = _stepper.findComponent("stepper-textfield", TextField);
        textfield.focus = true;
        
        var step:Stepper = _stepper.findComponent("stepper-step", Stepper);
        if (event.delta > 0) {
            step.increment();
        } else {
            step.deincrement();
        }
    }
    
    private function onStepChange(event:UIEvent) {
        var step:Stepper = _stepper.findComponent("stepper-step", Stepper);
        _stepper.pos = step.pos;
    }
    
    private function onStepMouseDown(event:MouseEvent) {
        var textfield:TextField = _stepper.findComponent("stepper-textfield", TextField);
        textfield.focus = true;
    }
    
    private function onTextFieldFocusIn(event:FocusEvent) {
        _stepper.addClass(":active");
    }
    
    private function onTextFieldFocusOut(event:FocusEvent) {
        _stepper.removeClass(":active");
    }
    
    private function onTextFieldChange(event:UIEvent) {
        var step:Stepper = _stepper.findComponent("stepper-step", Stepper);
        var textfield:TextField = _stepper.findComponent("stepper-textfield", TextField);
        step.pos = Std.parseFloat(textfield.text);
    }
}