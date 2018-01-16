import StORM
import PostgresStORM

class InteractionQuery {
    
    static func create(greetingId: Int, receiverId: Int) -> Interaction? {
        let createObj: Interaction = Interaction()
        do {
            let res = try createObj.sql("insert into \(InteractionTable.tableName) (\(InteractionTable.greeting), \(InteractionTable.receiver)) values($1, $2) returning \(InteractionTable.id)", params: ["\(greetingId)", "\(receiverId)"])
            let createdId: Int = res.getFieldInt(tupleIndex: 0, fieldIndex: 0) ?? 0
            return readById(createdId)
        } catch {
            print("Error while creating interaction: \(error)")
            return nil
        }
    }
    
    static func read() -> [Interaction] {
        var interactions = [Interaction]()
        let getObj: Interaction = Interaction()
        do {
            try getObj.select(columns: [InteractionTable.id, InteractionTable.greeting, InteractionTable.isRetributed, InteractionTable.isLikedBySender, InteractionTable.isLikedByReceiver], whereclause: "", params: [], orderby: [InteractionTable.id])
            interactions = getObj.rows()
        } catch {
            print("Error while reading interactions: \(error)")
        }
        return interactions
    }
    
    static func readById(_ id: Int) -> Interaction? {
        let getObj: Interaction = Interaction()
        do {
            try getObj.select(columns: [InteractionTable.id, InteractionTable.greeting, InteractionTable.isRetributed, InteractionTable.isLikedBySender, InteractionTable.isLikedByReceiver], whereclause: "\(InteractionTable.id) = $1", params: [id], orderby: [InteractionTable.id])
            let interactions = getObj.rows()
            return interactions.first
        } catch {
            print("Error while reading interaction by id: \(error)")
            return nil
        }
    }
    
    static func readByReceiverId(_ receiverId: Int) -> [Interaction] {
        var interactions: [Interaction] = [Interaction]()
        let getObj: Interaction = Interaction()
        do {
            try getObj.select(columns: [InteractionTable.id, InteractionTable.greeting, InteractionTable.isRetributed, InteractionTable.isLikedBySender, InteractionTable.isLikedByReceiver], whereclause: "\(InteractionTable.receiver) = $1", params: [receiverId], orderby: [InteractionTable.id])
            interactions = getObj.rows()
        } catch {
            print("Error while reading interaction by receiver id: \(error)")
        }
        return interactions
    }
    
    static func retribuite(interactionId: Int) -> Interaction? {
        let updateObj: Interaction = Interaction()
        do {
            let _ = try updateObj.sql("update \(InteractionTable.tableName) set \(InteractionTable.isRetributed) = $1 where \(InteractionTable.id) = $2", params: ["\(true)", "\(interactionId)"])
            return readById(interactionId)
        } catch {
            print("Error while updating interaction: \(error)")
            return nil
        }
    }
    
    static func update(_ interaction: Interaction) -> Interaction? {
        let updateObj: Interaction = Interaction()
        do {
            let _ = try updateObj.sql("update \(InteractionTable.tableName) set \(InteractionTable.isRetributed) = $1, \(InteractionTable.isLikedBySender) = $2, \(InteractionTable.isLikedByReceiver) = $3 where \(InteractionTable.id) = $4", params: ["\(interaction.isRetributed!)", "\(interaction.isLikedBySender!)", "\(interaction.isLikedByReceiver!)", "\(interaction.id!)"])
            return readById(interaction.id!)
        } catch {
            print("Error while updating interaction: \(error)")
            return nil
        }
    }
    
    static func like(interactionId: Int, userId: Int) -> Interaction? {
        let likeObj: Interaction = Interaction()
        let isSenderQuery = "select $1 = (select g.\(GreetingTable.creator) from \(GreetingTable.tableName) g inner join \(InteractionTable.tableName) i on g.\(GreetingTable.id) = i.\(InteractionTable.greeting) where i.\(InteractionTable.id) = $2) as is_sender"
        let isReceiverQuery = "select $1 = (select \(InteractionTable.receiver) from \(InteractionTable.tableName) where \(InteractionTable.id) = $2) as is_receiver"
        let senderLikeQuery = "update \(InteractionTable.tableName) set \(InteractionTable.isLikedBySender) = true where \(InteractionTable.id) = $1"
        let receiverLikeQuery = "update \(InteractionTable.tableName) set \(InteractionTable.isLikedByReceiver) = true where \(InteractionTable.id) = $1"
        
        do {
            let senderRes = try likeObj.sql(isSenderQuery, params: ["\(userId)", "\(interactionId)"])
            let receiverRes = try likeObj.sql(isReceiverQuery, params: ["\(userId)", "\(interactionId)"])
            
            if let isSender: Bool = senderRes.getFieldBool(tupleIndex: 0, fieldIndex: 0), isSender {
                
                let _ = try likeObj.sql(senderLikeQuery, params: ["\(interactionId)"])
                
            } else if let isReceiver: Bool = receiverRes.getFieldBool(tupleIndex: 0, fieldIndex: 0), isReceiver {
                
                let _ = try likeObj.sql(receiverLikeQuery, params: ["\(interactionId)"])
                
            } else {
                print("The user isn't either sender or receiver, or the interaction doesn't exist.")
                return nil
            }
            return readById(interactionId)
        } catch {
            print("Error while updating interaction: \(error)")
            return nil
        }
    }
    
    static func delete(_ id: Int) -> Interaction? {
        let deleteObj: Interaction = Interaction()
        let deletedInteraction = readById(id)
        do {
            let _ = try deleteObj.sql("delete from interaction where id = $1", params: ["\(id)"])
            return deletedInteraction
        } catch {
            print("Error while deleting interaction: \(error)")
            return nil
        }
    }
    
}

