<?php   
    /**
 * API Endpoint Router
 *
 * This PHP script serves as a simple API endpoint router, handling GET and POST requests for specific resources.
 *
 *
 * Usage:
 * 1. Include this script in your project.
 * 2. Define resource-specific logic in the 'get.php' and 'post.php' modules.
 * 3. Send requests to the appropriate endpoints defined in the 'switch' cases below.
 *
 * Example Usage:
 * - API_URL: http://localhost/demoproject/api
 * - GET request for employees: API_URL/employees
 * - GET request for jobs: API_URL/jobs
 * - POST request for adding employees: API_URL/addemployee (with JSON data in the request body)
 * - POST request for adding jobs: API_URL/addjob (with JSON data in the request body)
 *
 */

 if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');
}


if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, PUT,DELETE,OPTIONS");

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

    exit(0);
}


    // Include required modules
    require_once "./modules/get.php";
    require_once "./modules/post.php";
    require_once "./config/database.php";

    $con = new Connection();
    $pdo = $con->connect();

    // Initialize Get and Post objects
    $get = new Get($pdo);
    $post = new Post($pdo);

    // Check if 'request' parameter is set in the request
    if(isset($_REQUEST['request'])){
         // Split the request into an array based on '/'
        $request = explode('/', $_REQUEST['request']);
    }
    else{
         // If 'request' parameter is not set, return a 404 response
        echo "Not Found";
        http_response_code(404);
    }

    // Handle requests based on HTTP method
    switch($_SERVER['REQUEST_METHOD']){
        // Handle GET requests
        case 'GET':
            switch($request[0]){
                case 'getaccounts':
                    // Return JSON-encoded data for getting employees
                    if(count($request)>1){
                        echo json_encode($get->get_accounts($request[1]));
                    }
                    else{
                        echo json_encode($get->get_accounts());
                    }
                    break;
                
                case 'jobs':
                    // Return JSON-encoded data for getting jobs
                    echo json_encode($get->get_jobs());
                    break;
                
                default:
                    // Return a 403 response for unsupported requests
                    echo "This is forbidden";
                    http_response_code(403);
                    break;
            }
            break;
        // Handle POST requests    
        case 'POST':
            // Retrieves JSON-decoded data from php://input using file_get_contents
            $data = json_decode(file_get_contents("php://input"));
            switch($request[0]){
                case 'addAccount':
                    // Return JSON-encoded data for adding employees
                    echo json_encode($post->addAccount($data));
                    break;
                
                case 'deleteaccount':
                    echo json_encode($post->deleteaccount($request[1]));
                    break;
                
                case 'addjob':
                    // Return JSON-encoded data for adding jobs
                    echo json_encode($post->add_jobs($data));
                    break;
                
                default:
                    // Return a 403 response for unsupported requests
                    echo "This is forbidden";
                    http_response_code(403);
                    break;
            }
            break;
        default:
            // Return a 404 response for unsupported HTTP methods
            echo "Method not available";
            http_response_code(404);
        break;
    }

?>