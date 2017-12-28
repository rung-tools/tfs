(import inquirer
        [termcolor [colored]]
        [collections [OrderedDict]]
        [tabulate [tabulate]]
        [config [read-config]]
        [client [Client]])

(defn map [iterable f]
  (if (empty? iterable)
    []
    (+ [(f (car iterable))] (map (cdr iterable) f))))

(defn prompt-project-collection [client]
  (setv response (->
    (client.get "/_Apis/ProjectCollections")
    (get "value")
    (map (fn [item] (get item "name")))))
  (inquirer.List "project-collection"
    :message "Pick a project collection"
    :choices response))

(defn prompt-project [client project-collection]
  (setv response (->
    (client.get (+ "/" project-collection "/_Apis/Projects"))
    (get "value")
    (map (fn [item] (get item "name")))))
  (inquirer.List "project"
    :message "Pick a project"
    :choices response))

(defn title [text]
  (colored text "blue" :attrs ["bold"]))

(defn get-project-collections-table [client]
  (setv response (->
    (client.get "/_Apis/ProjectCollections")
    (get "value")
    (->> (map (fn [item] (OrderedDict [
      (, (title "Id") (get item "id"))
      (, (title "Name") (get item "name"))
      (, (title "Url") (get item "url"))]))))))
  (tabulate response :tablefmt "fancy_grid" :headers "keys"))

(defn list [args]
  (setv config (read-config))
  (setv client (Client
    (get config "url")
    (get config "username")
    (get config "token")))
  (setv project-collection
    (get (inquirer.prompt [(prompt-project-collection client)]) "project-collection"))
  (print (inquirer.prompt [(prompt-project client project-collection)])))
