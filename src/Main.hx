package;

// import drift.Drift;
import vector.Float4;
import vector.Float3;
import drift.UserList.UserList;
import js.Browser.document;
import js.html.ButtonElement;
import vector.Float2;

function main() {
    var canvas = document.createCanvasElement();
    canvas.width = 800;
    canvas.height = 600;

    var app = document.getElementById("app");
    app.appendChild(canvas);

    var v = new Float2(3, 4);
    var length = Float2.length(v); 
    trace('Length of vector v: $length'); // Should output 5
    trace('Float2 vector: ${v.toString()}');

    var v2 = new Float3(1, 2, 2);
    var length3 = Float3.length(v2);
    trace('Length of vector v2: $length3'); // Should output 3
    trace('Float3 vector: ${v2.toString()}');

    var v3 = new Float4(1, 2, 2, 1);
    var length4 = Float4.length(v3);
    trace('Length of vector v3: $length4'); // Should output 3
    trace('Float4 vector: ${v3.toString()}');

    var r1 = v.xx;
    trace('Swizzle v.xx: ${r1.toString()}');

    var r2 = v.yx;
    trace('Swizzle v.yx: ${r2.toString()}');

    var context = canvas.getContext('2d');
    context.fillStyle = "lightblue";
    context.fillRect(0, 0, canvas.width, canvas.height);

    var drifval = new UserList();
    trace("Drift value: " + drifval);
    
    trace("Canvas initialized with light blue background.");

    // Counter.setupCounter(cast(document.querySelector('#counter'), ButtonElement));
}

// class Counter {
// 	public static function setupCounter(element:ButtonElement) {
// 		var counter = 0;
// 		var setCounter = (count:Int) -> {
// 			counter = count;
// 			element.innerHTML = 'count is $counter';
// 		}
// 		element.addEventListener('click', () -> setCounter(counter + 1));
// 		setCounter(0);
// 	}
// }
