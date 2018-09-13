//  This file was automatically generated and should not be edited.

import Apollo

public final class FetchGameQuery: GraphQLQuery {
  public let operationDefinition =
    "query FetchGame($name: String) {\n  game(name: $name) {\n    __typename\n    ...GameDetails\n  }\n}"

  public var queryDocument: String { return operationDefinition.appending(GameDetails.fragmentDefinition) }

  public var name: String?

  public init(name: String? = nil) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("game", arguments: ["name": GraphQLVariable("name")], type: .object(Game.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(game: Game? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "game": game.flatMap { (value: Game) -> ResultMap in value.resultMap }])
    }

    /// Get a single game as identified by its name.
    public var game: Game? {
      get {
        return (resultMap["game"] as? ResultMap).flatMap { Game(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "game")
      }
    }

    public struct Game: GraphQLSelectionSet {
      public static let possibleTypes = ["Game"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(GameDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, displayName: String, coverUrl: String? = nil, viewersCount: Int? = nil, broadcastersCount: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "Game", "id": id, "displayName": displayName, "coverURL": coverUrl, "viewersCount": viewersCount, "broadcastersCount": broadcastersCount])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var gameDetails: GameDetails {
          get {
            return GameDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class FetchGamesQuery: GraphQLQuery {
  public let operationDefinition =
    "query FetchGames {\n  games {\n    __typename\n    edges {\n      __typename\n      cursor\n      node {\n        __typename\n        ...GameDetails\n      }\n    }\n    pageInfo {\n      __typename\n      hasNextPage\n      hasPreviousPage\n    }\n  }\n}"

  public var queryDocument: String { return operationDefinition.appending(GameDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("games", type: .object(Game.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(games: Game? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "games": games.flatMap { (value: Game) -> ResultMap in value.resultMap }])
    }

    /// Fetch games in order of descending popularity.
    /// By default returns 10.
    /// Tags are an array of tag ID as optional filters for games.
    public var games: Game? {
      get {
        return (resultMap["games"] as? ResultMap).flatMap { Game(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "games")
      }
    }

    public struct Game: GraphQLSelectionSet {
      public static let possibleTypes = ["GameConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("edges", type: .list(.nonNull(.object(Edge.selections)))),
        GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]? = nil, pageInfo: PageInfo) {
        self.init(unsafeResultMap: ["__typename": "GameConnection", "edges": edges.flatMap { (value: [Edge]) -> [ResultMap] in value.map { (value: Edge) -> ResultMap in value.resultMap } }, "pageInfo": pageInfo.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The list of games to display.
      public var edges: [Edge]? {
        get {
          return (resultMap["edges"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Edge] in value.map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge]) -> [ResultMap] in value.map { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
        }
      }

      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes = ["GameEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("cursor", type: .scalar(String.self)),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cursor: String? = nil, node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "GameEdge", "cursor": cursor, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var cursor: String? {
          get {
            return resultMap["cursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cursor")
          }
        }

        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Game"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(GameDetails.self),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, displayName: String, coverUrl: String? = nil, viewersCount: Int? = nil, broadcastersCount: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "Game", "id": id, "displayName": displayName, "coverURL": coverUrl, "viewersCount": viewersCount, "broadcastersCount": broadcastersCount])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var gameDetails: GameDetails {
              get {
                return GameDetails(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes = ["PageInfo"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("hasPreviousPage", type: .nonNull(.scalar(Bool.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hasNextPage: Bool, hasPreviousPage: Bool) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "hasPreviousPage": hasPreviousPage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }

        public var hasPreviousPage: Bool {
          get {
            return resultMap["hasPreviousPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasPreviousPage")
          }
        }
      }
    }
  }
}

public struct GameDetails: GraphQLFragment {
  public static let fragmentDefinition =
    "fragment GameDetails on Game {\n  __typename\n  id\n  displayName\n  coverURL\n  viewersCount\n  broadcastersCount\n}"

  public static let possibleTypes = ["Game"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
    GraphQLField("coverURL", type: .scalar(String.self)),
    GraphQLField("viewersCount", type: .scalar(Int.self)),
    GraphQLField("broadcastersCount", type: .scalar(Int.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, displayName: String, coverUrl: String? = nil, viewersCount: Int? = nil, broadcastersCount: Int? = nil) {
    self.init(unsafeResultMap: ["__typename": "Game", "id": id, "displayName": displayName, "coverURL": coverUrl, "viewersCount": viewersCount, "broadcastersCount": broadcastersCount])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The game's unique Twitch identifier.
  /// It is used to associate games with product offers.
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  /// A publicly visible name used for display purposes.
  public var displayName: String {
    get {
      return resultMap["displayName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "displayName")
    }
  }

  /// URL to a cover image.
  /// The image dimensions are specifiable via the `height` and `width` parameters.
  /// 
  /// If `height` or `width` are not specified, the URL will contain
  /// the template strings `{height}` and/or `{width}` in their respective places.
  public var coverUrl: String? {
    get {
      return resultMap["coverURL"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "coverURL")
    }
  }

  /// Number of viewers currently watching a stream which features this game.
  public var viewersCount: Int? {
    get {
      return resultMap["viewersCount"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "viewersCount")
    }
  }

  /// Number of broadcasters streaming this game.
  public var broadcastersCount: Int? {
    get {
      return resultMap["broadcastersCount"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "broadcastersCount")
    }
  }
}