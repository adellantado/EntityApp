/**
 * Created by ader on 7/13/2015.
 */
package {
import flash.events.MouseEvent;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;

import mx.core.DragSource;
import mx.core.UIComponent;
import mx.managers.DragManager;

public class EntityShape extends UIComponent {

    public static const SIZE:int = 40;

    protected var entity:Entity;

    protected var watchers:Array = [];

    private var _draggable:Boolean;

    public function EntityShape(entity:Entity, draggable:Boolean = true) {
        super();
        this.entity = entity || new Entity();
        _draggable = draggable;

        watchers.push(BindingUtils.bindProperty(this, "x", this.entity, "x"));
        watchers.push(BindingUtils.bindProperty(this, "y", this.entity, "y"));

        if (_draggable)
            this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
    }

    public function get draggable():Boolean {
        return _draggable;
    }

    public function dispose():void {
        if (draggable)
            this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

        watchers.forEach(function (watcher:ChangeWatcher, ...args):void {
            watcher.unwatch();
        });
    }

    protected function draw():void {
        this.graphics.beginFill(0x0000ff);
        this.graphics.drawRect(0, 0, width, height);
        this.graphics.endFill();
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        var dragInitiator:UIComponent = UIComponent(event.currentTarget);
        var ds:DragSource = new DragSource();
        ds.addData(dragInitiator, "shape");

        DragManager.doDrag(dragInitiator, ds, event);
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        draw();
    }

    override protected function measure():void {
        super.measure();
        measuredWidth = SIZE;
        measuredMinWidth = SIZE;
        measuredHeight = SIZE;
        measuredMinHeight = SIZE;
    }

    override public function set x(value:Number):void {
        super.x = value;
        entity.x = value;
    }

    override public function set y(value:Number):void {
        super.y = value;
        entity.y = value;
    }
}
}
