
import Foundation

protocol BotSynchroniser {
    func synchronise(_ bot: Bot, completion: (Bot) -> ())
    func delete(_ bot: Bot, completion: (Bool) -> ())
}
