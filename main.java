import java.io.*;
import java.util.*;


public class Main {
    final int N = 5;
    final int max_len = 30;
    long[][] route_length = new long[N][N];
    int[][] input_route_length = new int[N][N];
    long[][][] path_count = new long[N][N][max_len + 1];
    long[][][] path_count_with_len = new long[N][N][max_len + 1];

    public void solve() {
        InputStreamReader inputStreamReader = new InputStreamReader(System.in);
        Scanner scanner = new Scanner(inputStreamReader);
        for (int vertex_from = 0; vertex_from < N; ++vertex_from)
            for (int vertex_to = 0; vertex_to < N; ++vertex_to) {
                route_length[vertex_from][vertex_to] = 1000 * 1000 * 1000;
                input_route_length[vertex_from][vertex_to] = 1000 * 1000 * 1000;
            }
        while (scanner.hasNext()) {
            String edge = null;
            try {
                edge = scanner.next();
                edge = edge.replace(",", "");
                int vertex_from = edge.charAt(0) - 'A';
                int vertex_to = edge.charAt(1) - 'A';
                int edge_length = Integer.parseInt(edge.substring(2));
                input_route_length[vertex_from][vertex_to] = edge_length;
                route_length[vertex_from][vertex_to] = edge_length;
                path_count[vertex_from][vertex_to][1] = 1;
                path_count_with_len[vertex_from][vertex_to][edge_length] = 1;
            } catch (Exception e) {
                System.out.println("You have entered wrong input format, try to enter it again");
            }
        }
        for (int intermediate_vertex = 0; intermediate_vertex < N; ++intermediate_vertex)
            for (int vertex_from = 0; vertex_from < N; ++vertex_from)
                for (int vertex_to = 0; vertex_to < N; ++vertex_to)
                    if (route_length[vertex_from][intermediate_vertex] != 200 &&
                            route_length[intermediate_vertex][vertex_to] != 200)
                        route_length[vertex_from][vertex_to] = Math.min(
                                route_length[vertex_from][vertex_to],
                                route_length[vertex_from][intermediate_vertex] + route_length[intermediate_vertex][vertex_to]
                        );
        for (int current_route_length = 0; current_route_length < 30; ++current_route_length) {
            for (int vertex_from = 0; vertex_from < N; ++vertex_from)
                for (int vertex_to = 0; vertex_to < N; ++vertex_to) {
                    for (int next_vertex = 0; next_vertex < N; ++next_vertex) {
                        int next_route_length = current_route_length + 1;
                        path_count[vertex_from][next_vertex][next_route_length] +=
                                path_count[vertex_from][vertex_to][current_route_length] * path_count[vertex_to][next_vertex][1];
                    }
                }
        }

        for (int current_route_length = 0; current_route_length < 30; ++current_route_length) {
            for (int vertex_from = 0; vertex_from < N; ++vertex_from)
                for (int vertex_to = 0; vertex_to < N; ++vertex_to) {
                    for (int next_vertex = 0; next_vertex < N; ++next_vertex) {
                        int next_route_length = current_route_length + input_route_length[vertex_to][next_vertex];
                        if (next_route_length < 30)
                            path_count_with_len[vertex_from][next_vertex][next_route_length] +=
                                    path_count_with_len[vertex_from][vertex_to][current_route_length] * path_count[vertex_to][next_vertex][1];
                    }
                }
        }

        long[] answer = new long[11];

        answer[1] = input_route_length[0][1] + input_route_length[1][2];
        answer[2] = input_route_length[0][3];
        answer[3] = input_route_length[0][3] + input_route_length[3][2];
        answer[4] = input_route_length[0][4] + input_route_length[4][1] + input_route_length[1][2] + input_route_length[2][3];
        answer[5] = input_route_length[0][4] + input_route_length[4][3];
        answer[6] = path_count[2][2][1] + path_count[2][2][2] + path_count[2][2][3];
        answer[7] = path_count[0][2][4];
        answer[8] = route_length[0][2];
        answer[9] = route_length[1][1];
        answer[10] = 0;

        System.out.println(path_count_with_len[2][4][2]);
        System.out.println(path_count_with_len[4][1][3]);
        System.out.println(path_count_with_len[2][1][5]);


        for (int len = 0; len < 30; ++len) {
            answer[10] += path_count_with_len[2][2][len];
        }
        for (int output = 1; output <= 10; ++output) {
            System.out.print("Output #" + Integer.toString(output) + ": ");
            if ((output <= 5 || output == 8 || output == 9) && answer[output] >= 1000 * 1000 * 1000) {
                System.out.println("NO SUCH ROUTE");
            } else {
                System.out.println(answer[output]);
            }
        }
    }

    public static void main(String[] args) {

        Main solver = new Main();
        solver.solve();

    }
}

