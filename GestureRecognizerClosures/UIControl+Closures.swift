import UIKit

public extension UIControl {

    /// Adds a handler that will be invoked for the specified control events
    public func on(controlEvents: UIControlEvents, invokeHandler handler: (UIControl) -> Void) -> AnyObject {
        let closureHandler = ClosureHandler(handler: handler, control: self)
        addTarget(closureHandler, action: ClosureHandlerSelector, forControlEvents: controlEvents)
        var handlers = self.handlers ?? Set<ClosureHandler<UIControl>>()
        handlers.insert(closureHandler)
        self.handlers = handlers
        return closureHandler
    }

    /// Removes a handler from the control
    public func removeHandler(handler: AnyObject) {
        guard let handler = handler as? ClosureHandler<UIControl> else { return }
        removeTarget(handler, action: ClosureHandlerSelector, forControlEvents: .AllEvents)
        if var handlers = self.handlers {
            handlers.remove(handler)
            self.handlers = handlers
        }
    }
}

private var HandlerKey: UInt8 = 0

private extension UIControl {

    private var handlers: Set<ClosureHandler<UIControl>>? {
        get { return objc_getAssociatedObject(self, &HandlerKey) as? Set<ClosureHandler<UIControl>> }
        set { objc_setAssociatedObject(self, &HandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}