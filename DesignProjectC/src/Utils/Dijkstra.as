package Utils
{
	public class Dijkstra
	{
		private var length:int; // 배열의 최대길이
		private var matrix:Array; // 인접-행렬
		private var check_route:Vector.<Boolean> = new Vector.<Boolean>; // 중복체크 배열
		private var previous:Vector.<int> = new Vector.<int>; // 역추적을 위한 배열
		private var dist:Vector.<int> = new Vector.<int>; // 거리 누적 배열
		
		
		private var check:Vector.<int> = new Vector.<int>; // 
		
		private var Path:Vector.<Vector.<int>> = new Vector.<Vector.<int>>;
		private var Pathcounter:int;
		
		public function Dijkstra(inputFile:Array)
		{
			length = 280;
			matrix = inputFile;
			Pathcounter = 0;
			
			for (var i:int = 0; i < length; i++)
				previous[i] = -1;
		}
	
		public function ShortestPath(n:int, v:Number):void // 빠른길로 가중치를 갱신
		{
			// dist[j] (0 <= j < n) 는 v에서 j까지의 최단 경로의 길이이다.
			// 간선의 길이는 matrix[i][j]의 값 이다.
			for (var i:int = 0; i < n; i++)
			{// 초기화
				check_route[i] = false;
				dist[i] = matrix[v][i];
			}
			
			check_route[v] = true; // 시작점은 바로 S에 속해짐
			dist[v] = 0; // 자신까지의 거리 = 0
			
			/*cout << "=======================================================================" << endl;
			cout << setw(5) << "반복|" << setw(5) << "선택정점|";*/
			
			//for (int i = 0; i < n; i++)
			//	cout << setw(5) << " dist[" << i << "] ";
			//cout << endl;
			var u:int = -1;
			// 정점 v에서 부터의 n-1 경로를 설정
			for (i = 0; i < n; i++)
			{
				//print_route(i, u);
				u = choose(n); // choose 는 check_route[w] = false 이고,
				// dist[u] = minimum dist[w] 가 되는 u를 반환
				check_route[u] = true;
				// ====== 최단거리로 갱신 =======//
				for (var w:int = 0; w < n; w++)
				{
					if (!check_route[w] && dist[u] + matrix[u][w] < dist[w])
					{
						dist[w] = dist[u] + matrix[u][w];
						previous[w] = u;
					}
				}
				// ============================== //
			}
		}
		
		public function choose(n:int):int // 시작~목적지 까지의 누적 길이가 가장 적은 정점을 반환
		{
			var min:int = 9999;
			var select_v:int = 0;
			for (var w:int = 0; w < n; w++)
			{
				if (check_route[w] == false && dist[w] < min)
				{
					select_v = w;
					min = dist[w];
				}
			}
			return select_v;
		}

		public function generatePath(v:int, end:int):void
		{
			Path[Pathcounter].push(end);
			while (previous[end] != -1)
			{
				Path[Pathcounter].push(previous[end]);
				check[previous[end]] = 1;
				end = previous[end];
			}
			
			if (Path[Pathcounter].push() > 1)
				Pathcounter++;
		}
		
		public function MakeAllPath():void
		{
			for (var i:int = 0; i < length; i++)
				check[i] = -1;
			
			for (i = length-1; i > 0; i--)
			{
				for (var j:int = 0; j < length; j++)
					previous[j] = -1;
				ShortestPath(280, 0);
				if (check[i] == -1)
					generatePath(0, i);
			}
			
			for (i = 0; i < Pathcounter; i++)
			{
				Path[i].push(0);
			}
		}
		
		public function PathComp():void
		{
		}
		
		public function CompChecker():void
		{
		}
	}
}