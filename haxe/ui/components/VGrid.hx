package haxe.ui.components;

import haxe.ui.layouts.VerticalGridLayout;
import haxe.ui.core.Component;
import haxe.ui.core.IClonable;

//@:dox(icon="")  //TODO
class VGrid extends Component implements IClonable<VGrid> {
    public function new() {
        super();

        columns = 1;
    }

    //***********************************************************************************************************
    // Internals
    //***********************************************************************************************************
    private override function createDefaults() {
        _defaultLayout = new VerticalGridLayout();
    }

    //***********************************************************************************************************
    // Public API
    //***********************************************************************************************************
    private var _columns:Int;
    @:clonable public var columns(get, set):Int;
    private function get_columns():Int {
        return _columns;
    }

    private function set_columns(value:Int):Int {
        if(_columns != value)
        {
            _columns = value;

            cast(layout, VerticalGridLayout).columns = value;
            invalidateLayout();
        }
        return value;
    }
}
